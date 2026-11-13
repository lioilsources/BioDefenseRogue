// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreTh = LoreTable(
  names: {
    'upgrade.opsonin': 'ออปโซไนเซชัน (IgG)',
    'upgrade.histamin': 'ฮิสตามีน',
    'upgrade.pyrogen': 'สารก่อไข้ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'ไมโทคอนเดรีย',
    'upgrade.membrana': 'ความลื่นไหลของเยื่อหุ้ม',
    'upgrade.cytotoxin': 'แกรนูลพิษต่อเซลล์',
    'enemy.swarmer': 'ฝูง (ค็อกไค)',
    'enemy.tank': 'ไบโอฟิล์ม (กลุ่มสแตฟิโลค็อกคัส)',
    'enemy.boss': 'สแตฟิโลค็อกคัสสีทอง (บอส)',
    'enemy.boss.phase2': 'สแตฟิโลค็อกคัสสีทอง — ระยะที่สอง',
    'status.opsonized': 'ถูกทำเครื่องหมาย (ออปโซไนซ์)',
    'status.slowed': 'ช้าลง',
    'damage.kinetic': 'ความเสียหายทางกายภาพ',
    'damage.inflammatory': 'ความเสียหายจากการอักเสบ',
    'mechanic.fever': 'ไข้',
    'fever.normo': 'อุณหภูมิปกติ',
    'fever.febrile': 'ไข้ต่ำ',
    'fever.hyper': 'ไข้สูง',
    'fever.critical': 'ไข้วิกฤต',
    'room.combat': 'ต่อสู้',
    'room.elite': 'อีลิต',
    'room.treasure': 'รักษา',
    'room.boss': 'บอส',
    'meta.memoryCells': 'เซลล์ความจำ',
    'meta.vaccination': 'การฉีดวัคซีน',
    'ability.phagocytosis': 'ฟาโกไซโทซิส (การโจมตีพื้นฐาน)',
    'ability.dash': 'การเคลื่อนที่แบบอะมีบา (พุ่งตัว)',
    'ability.chargeDash': 'เท้าเทียม (พุ่งตัวแบบชาร์จ)',
    'ability.oxidativeBurst': 'การระเบิดออกซิเดชัน (ROS)',
    'ability.lysozymeBurst': 'การยิงไลโซไซม์ชุด',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'สีเทียม (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'การโจมตีจะทำเครื่องหมายเป้าหมาย — รับความเสียหาย {{balance.opsonizedDamageTakenMulti|pctDelta}} เป็นเวลา {{balance.opsonizedDuration|s}}',
    'upgrade.histamin':
        'การโจมตีทำให้เป้าหมายช้าลง {{balance.slowedSpeedMulti|pctLess}} เป็นเวลา {{balance.slowedDuration|s}}',
    'upgrade.pyrogen':
        'ความเสียหาย {{balance.pyrogenDamageMulti|pctDelta}} แต่ทุกนัดที่ยิงทำให้ไข้สูงขึ้น',
    'upgrade.treg':
        'ไข้ลดลงเร็วขึ้น {{balance.tregDecayBonus|degC}} ต่อวินาที',
    'upgrade.mitochondrie':
        'การโจมตีพิเศษใช้ ATP น้อยลง {{balance.mitochondrieCostMulti|pctLess}}',
    'upgrade.membrana':
        'จำนวนพุ่งตัวสูงสุด +{{balance.membranaExtraDashCharges|int}}',
    'upgrade.cytotoxin':
        'ความเสียหายพื้นฐานของกระสุน {{balance.cytotoxinDamageMulti|pctDelta}}',
  },
);
