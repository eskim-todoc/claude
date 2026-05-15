---
name: Archive 모듈 인덱스
purpose: 루트 archive 모듈별 최종 업데이트 인덱스 (Wiki sync 진입판단용)
type: tasks/메타
applies_to: [root]
tags: [meta, archive, index, wiki-sync]
---

# Archive 모듈 인덱스 — 루트

**TL;DR**: 루트(`E:\Claude`)의 `_archive/` 하위 모듈별 최종 업데이트 날짜 인덱스. Wiki 등 외부 소비자는 본 파일만 읽어 마지막 sync 시점 이후 변경된 모듈만 식별 가능. 갱신은 Claude의 archive 처리 흐름에서 자동 수행 ([`작업 진행 규칙.md §6.1`](../../지침/일반/작업%20진행%20규칙.md)).

## 운영 메모

- 정렬: **최종 업데이트 내림차순** → 동률 시 **작업 수 내림차순** → 그래도 동률이면 모듈명 사전순
- 갱신 트리거: 작업 archive 처리 시 — [`작업 진행 규칙.md §6.1`](../../지침/일반/작업%20진행%20규칙.md) 5번 단계가 본 파일 자동 갱신
- 추적 범위: archive **신규/갱신**. 기존 archive 파일 *수정*은 추적 대상 아님

## 모듈 인덱스

| 모듈 | 최종 업데이트 | 최근 작업 | 작업 수 |
|---|---|---|---|
| meta | 2026-05-15 | [docs-structure-redesign](meta/docs-structure-redesign/) | 10 |
