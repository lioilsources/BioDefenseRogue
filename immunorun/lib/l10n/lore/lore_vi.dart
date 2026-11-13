// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreVi = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonin hóa (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Chất gây sốt (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Ty thể',
    'upgrade.membrana': 'Tính lưu động của màng',
    'upgrade.cytotoxin': 'Hạt gây độc tế bào',
    'enemy.swarmer': 'Bầy (cầu khuẩn)',
    'enemy.tank': 'Màng sinh học (cụm tụ cầu)',
    'enemy.boss': 'Tụ cầu vàng (trùm)',
    'enemy.boss.phase2': 'Tụ cầu vàng — giai đoạn hai',
    'status.opsonized': 'Bị đánh dấu (opsonin hóa)',
    'status.slowed': 'Bị làm chậm',
    'damage.kinetic': 'Sát thương vật lý',
    'damage.inflammatory': 'Sát thương viêm',
    'mechanic.fever': 'Sốt',
    'fever.normo': 'Nhiệt độ bình thường',
    'fever.febrile': 'Sốt nhẹ',
    'fever.hyper': 'Sốt cao',
    'fever.critical': 'Sốt nguy kịch',
    'room.combat': 'Chiến đấu',
    'room.elite': 'Tinh nhuệ',
    'room.treasure': 'Hồi phục',
    'room.boss': 'Trùm',
    'meta.memoryCells': 'Tế bào nhớ',
    'meta.vaccination': 'Tiêm chủng',
    'ability.phagocytosis': 'Thực bào (đòn cơ bản)',
    'ability.dash': 'Chuyển động kiểu amip (lướt)',
    'ability.chargeDash': 'Chân giả (lướt tích lực)',
    'ability.oxidativeBurst': 'Bùng nổ oxy hóa (ROS)',
    'ability.lysozymeBurst': 'Loạt bắn lysozyme',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Màu giả (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Đòn trúng đánh dấu mục tiêu — nó chịu {{balance.opsonizedDamageTakenMulti|pctDelta}} sát thương trong {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Đòn trúng làm mục tiêu chậm đi {{balance.slowedSpeedMulti|pctLess}} trong {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} sát thương, nhưng mỗi phát bắn làm cơn sốt tăng.',
    'upgrade.treg':
        'Cơn sốt giảm nhanh hơn {{balance.tregDecayBonus|degC}} mỗi giây.',
    'upgrade.mitochondrie':
        'Đòn đặc biệt tốn ít hơn {{balance.mitochondrieCostMulti|pctLess}} ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} lượt lướt tối đa.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} sát thương cơ bản của đạn.',
  },
);
