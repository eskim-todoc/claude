<#
.SYNOPSIS
  작업 완료 커스텀 알림 팝업 (웜 페이퍼 테마, WPF).
.DESCRIPTION
  화면 우하단에 크림 베이지 카드 + 테라코타 글로우 아이콘(Claude sunburst) 토스트를
  슬라이드-인 → N초 유지 → 페이드아웃으로 띄운다. 색·타이포는 지침/문서/테마 토큰.md(웜 페이퍼 SSOT).
  slack-notify.ps1이 detached(-Sta -WindowStyle Hidden)로 호출한다. 모든 실패는 silent(exit 0).
.NOTES
  STA 필수: powershell.exe -Sta 로 실행. 외부 모듈 의존 없음(.NET WPF 내장).
#>
param(
    [string]$Summary = '작업이 완료되었습니다',
    [string]$Title   = '작업 완료',
    [int]$Seconds    = 6
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

try {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml
} catch { exit 0 }

# ── Claude sunburst(12-포인트 별) Path 데이터를 InvariantCulture로 생성 ──
function tdc_Build-SparkGeometry {
    param([double]$Cx = 22, [double]$Cy = 22, [int]$Spikes = 12, [double]$ROuter = 13, [double]$RInner = 4)
    $ci = [System.Globalization.CultureInfo]::InvariantCulture
    $pts = $Spikes * 2
    $sb  = New-Object System.Text.StringBuilder
    for ($k = 0; $k -lt $pts; $k++) {
        $r    = if ($k % 2 -eq 0) { $ROuter } else { $RInner }
        $ang  = ($k * (360.0 / $pts) - 90.0) * [Math]::PI / 180.0
        $x    = $Cx + $r * [Math]::Cos($ang)
        $y    = $Cy + $r * [Math]::Sin($ang)
        $cmd  = if ($k -eq 0) { 'M' } else { 'L' }
        [void]$sb.Append($cmd + $x.ToString('0.###', $ci) + ',' + $y.ToString('0.###', $ci) + ' ')
    }
    [void]$sb.Append('Z')
    return $sb.ToString()
}

function tdc_Show-CompletionToast {
    param([string]$Summary, [string]$Title, [int]$Seconds)

    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Width="392" SizeToContent="Height" WindowStartupLocation="Manual"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False" ShowActivated="False" ResizeMode="NoResize"
        FontFamily="Segoe UI, Malgun Gothic, sans-serif">
  <Border Margin="16" CornerRadius="14" Background="#FBF7EE" BorderBrush="#E2D5BC" BorderThickness="1">
    <Border.Effect>
      <DropShadowEffect BlurRadius="26" ShadowDepth="5" Direction="270" Opacity="0.26" Color="#33291C"/>
    </Border.Effect>
    <Border.RenderTransform>
      <TranslateTransform x:Name="slide" X="44"/>
    </Border.RenderTransform>
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <Grid Grid.Row="0" Margin="16,15,16,15">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- 글로우 아이콘 (변형 B) -->
        <Grid Grid.Column="0" Width="44" Height="44" VerticalAlignment="Top" Margin="0,1,14,0">
          <Ellipse Width="44" Height="44">
            <Ellipse.Fill>
              <RadialGradientBrush GradientOrigin="0.35,0.30" Center="0.5,0.5" RadiusX="0.65" RadiusY="0.65">
                <GradientStop Color="#D9764F" Offset="0"/>
                <GradientStop Color="#C15F3C" Offset="0.6"/>
                <GradientStop Color="#A94E2E" Offset="1"/>
              </RadialGradientBrush>
            </Ellipse.Fill>
            <Ellipse.Effect>
              <DropShadowEffect BlurRadius="12" ShadowDepth="2" Direction="270" Color="#C15F3C" Opacity="0.55"/>
            </Ellipse.Effect>
          </Ellipse>
          <Path x:Name="spark" Fill="#FBF7EE" Stretch="None" HorizontalAlignment="Center" VerticalAlignment="Center"/>
        </Grid>

        <!-- 콘텐츠 -->
        <StackPanel Grid.Column="1">
          <Grid Margin="0,0,0,1">
            <TextBlock Text="Claude Code" Foreground="#C15F3C" FontSize="11" FontWeight="SemiBold" HorizontalAlignment="Left"/>
            <TextBlock x:Name="timeLabel" Foreground="#6E5F48" FontSize="11" HorizontalAlignment="Right" Margin="0,0,16,0"/>
          </Grid>
          <TextBlock x:Name="titleLabel" Foreground="#33291C" FontSize="14" FontWeight="Bold" Margin="0,1,0,3"/>
          <TextBlock x:Name="summaryLabel" Foreground="#6B5C46" FontSize="12.5" TextWrapping="Wrap"
                     MaxHeight="36" TextTrimming="CharacterEllipsis" LineHeight="16"/>
        </StackPanel>
      </Grid>

      <!-- 진행 바 (남은 시간) -->
      <Border x:Name="progressTrack" Grid.Row="1" Height="3" Background="#F5DECB" CornerRadius="0,0,13,13">
        <Border x:Name="progressBar" HorizontalAlignment="Left" Background="#C15F3C" CornerRadius="0,0,0,13"/>
      </Border>

      <!-- 닫기 -->
      <TextBlock x:Name="closeBtn" Grid.Row="0" Text="&#x2715;" Foreground="#6E5F48" FontSize="13"
                 HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,10,14,0"
                 Opacity="0.55" Cursor="Hand"/>
    </Grid>
  </Border>
</Window>
'@

    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)

    # 요소 채우기
    $window.FindName('spark').Data         = [System.Windows.Media.Geometry]::Parse((tdc_Build-SparkGeometry))
    $window.FindName('titleLabel').Text    = $Title
    $window.FindName('summaryLabel').Text  = $Summary
    try { $window.FindName('timeLabel').Text = (Get-Date -Format 'tt h:mm') } catch { $window.FindName('timeLabel').Text = (Get-Date -Format 'HH:mm') }

    $slide    = $window.FindName('slide')
    $pbar     = $window.FindName('progressBar')
    $ptrack   = $window.FindName('progressTrack')
    $closeBtn = $window.FindName('closeBtn')

    $script:closing = $false
    $doClose = {
        if ($script:closing) { return }
        $script:closing = $true
        $fo = New-Object System.Windows.Media.Animation.DoubleAnimation
        $fo.From = $window.Opacity; $fo.To = 0
        $fo.Duration = [System.Windows.Duration]([TimeSpan]::FromMilliseconds(380))
        $fo.add_Completed({ try { $window.Close() } catch {} })
        $window.BeginAnimation([System.Windows.Window]::OpacityProperty, $fo)
    }

    $closeBtn.Add_MouseLeftButtonUp({ & $doClose })
    $window.Add_MouseRightButtonUp({ & $doClose })

    $window.Add_Loaded({
        # 우하단 배치 (작업표시줄 제외)
        try {
            $wa = [System.Windows.SystemParameters]::WorkArea
            $window.Left = $wa.Right  - $window.ActualWidth  - 12
            $window.Top  = $wa.Bottom - $window.ActualHeight - 12
        } catch {}

        # 슬라이드-인 + 페이드-인
        $ease = New-Object System.Windows.Media.Animation.CubicEase
        $ease.EasingMode = 'EaseOut'
        $sa = New-Object System.Windows.Media.Animation.DoubleAnimation
        $sa.From = 44; $sa.To = 0
        $sa.Duration = [System.Windows.Duration]([TimeSpan]::FromMilliseconds(420))
        $sa.EasingFunction = $ease
        $slide.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $sa)

        $fi = New-Object System.Windows.Media.Animation.DoubleAnimation
        $fi.From = 0; $fi.To = 1
        $fi.Duration = [System.Windows.Duration]([TimeSpan]::FromMilliseconds(320))
        $window.BeginAnimation([System.Windows.Window]::OpacityProperty, $fi)

        # 진행 바 카운트다운 (전체폭 → 0, N초)
        try {
            $pbar.Width = $ptrack.ActualWidth
            $pa = New-Object System.Windows.Media.Animation.DoubleAnimation
            $pa.From = $ptrack.ActualWidth; $pa.To = 0
            $pa.Duration = [System.Windows.Duration]([TimeSpan]::FromSeconds($Seconds))
            $pbar.BeginAnimation([System.Windows.FrameworkElement]::WidthProperty, $pa)
        } catch {}

        # N초 후 자동 닫힘
        $timer = New-Object System.Windows.Threading.DispatcherTimer
        $timer.Interval = [TimeSpan]::FromSeconds($Seconds)
        $timer.add_Tick({ $timer.Stop(); & $doClose })
        $timer.Start()

        # 안전 하드 타임아웃: N+4초 후 강제 종료
        $hard = New-Object System.Windows.Threading.DispatcherTimer
        $hard.Interval = [TimeSpan]::FromSeconds($Seconds + 4)
        $hard.add_Tick({ $hard.Stop(); try { $window.Close() } catch {} })
        $hard.Start()
    })

    # 포커스 비탈취 표시 + 자체 메시지 루프(detached 프로세스 생존)
    $window.Show()
    $window.Add_Closed({ [System.Windows.Threading.Dispatcher]::CurrentDispatcher.InvokeShutdown() })
    [System.Windows.Threading.Dispatcher]::Run()
}

try {
    if (-not $Summary) { $Summary = '작업이 완료되었습니다' }
    if ($Seconds -lt 2 -or $Seconds -gt 30) { $Seconds = 6 }
    tdc_Show-CompletionToast -Summary $Summary -Title $Title -Seconds $Seconds
} catch {
    exit 0
}
