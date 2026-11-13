// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreKo = LoreTable(
  names: {
    'upgrade.opsonin': '옵소닌화 (IgG)',
    'upgrade.histamin': '히스타민',
    'upgrade.pyrogen': '발열원 (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': '미토콘드리아',
    'upgrade.membrana': '막 유동성',
    'upgrade.cytotoxin': '세포독성 과립',
    'enemy.swarmer': '무리 (구균)',
    'enemy.tank': '바이오필름 (포도상구균 덩어리)',
    'enemy.boss': '황색포도상구균 (보스)',
    'enemy.boss.phase2': '황색포도상구균 — 2단계',
    'status.opsonized': '표시됨 (옵소닌화)',
    'status.slowed': '느려짐',
    'damage.kinetic': '물리 피해',
    'damage.inflammatory': '염증 피해',
    'mechanic.fever': '발열',
    'fever.normo': '정상 체온',
    'fever.febrile': '미열',
    'fever.hyper': '고열',
    'fever.critical': '위험한 고열',
    'room.combat': '전투',
    'room.elite': '엘리트',
    'room.treasure': '회복',
    'room.boss': '보스',
    'meta.memoryCells': '기억 세포',
    'meta.vaccination': '예방 접종',
    'ability.phagocytosis': '식세포 작용 (기본 공격)',
    'ability.dash': '아메바 운동 (대시)',
    'ability.chargeDash': '위족 (충전 대시)',
    'ability.oxidativeBurst': '산화적 폭발 (ROS)',
    'ability.lysozymeBurst': '라이소자임 일제 사격',
    'resource.atp': 'ATP',
    'mechanic.microscope': '가짜 색 (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        '공격이 대상을 표시해요 — {{balance.opsonizedDuration|s}} 동안 받는 피해 {{balance.opsonizedDamageTakenMulti|pctDelta}}.',
    'upgrade.histamin':
        '공격이 대상을 {{balance.slowedDuration|s}} 동안 {{balance.slowedSpeedMulti|pctLess}} 느리게 해요.',
    'upgrade.pyrogen':
        '피해 {{balance.pyrogenDamageMulti|pctDelta}}, 하지만 쏠 때마다 열이 올라요.',
    'upgrade.treg':
        '열이 초당 {{balance.tregDecayBonus|degC}} 더 빨리 내려가요.',
    'upgrade.mitochondrie':
        '특수 공격의 ATP 소모가 {{balance.mitochondrieCostMulti|pctLess}} 줄어요.',
    'upgrade.membrana':
        '최대 대시 충전 +{{balance.membranaExtraDashCharges|int}}.',
    'upgrade.cytotoxin':
        '투사체 기본 피해 {{balance.cytotoxinDamageMulti|pctDelta}}.',
  },
);
