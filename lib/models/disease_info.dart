class DiseaseTranslation {
  final String english;
  final String urdu;

  const DiseaseTranslation({required this.english, required this.urdu});
}

class DiseaseInfo {
  final String id;
  final DiseaseTranslation name;
  final DiseaseTranslation description;
  final DiseaseTranslation treatment;
  final String severity;
  final List<DiseaseTranslation> symptoms;
  final List<DiseaseTranslation> preventionTips;

  const DiseaseInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.treatment,
    required this.severity,
    required this.symptoms,
    required this.preventionTips,
  });

  static const Map<String, DiseaseInfo> diseaseDatabase = {
    'cotton_bacterial_blight': DiseaseInfo(
      id: 'cotton_bacterial_blight',
      name: DiseaseTranslation(english: 'Cotton Bacterial Blight', urdu: 'کاٹن بیکٹیریل بلائٹ'),
      description: DiseaseTranslation(
        english:
            'A bacterial disease causing angular leaf spots and boll rot in cotton plants. It can significantly reduce cotton yield and quality.',
        urdu:
            'ایک بیکٹیریل بیماری جو کاپاس کے پودوں میں کونیی پتوں کے دھبے اور پھلیوں کی سڑن کا سبب بنتی ہے۔ یہ کپاس کی پیداوار اور معیار کو نمایاں طور پر کم کر سکتی ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Use disease-free certified seeds. Apply copper-based bactericides or antibiotics like streptomycin. Practice crop rotation with non-host crops. Remove and destroy infected plant debris.',
        urdu:
            'بیماری سے پاک تصدیق شدہ بیج استعمال کریں۔ کاپر پر مبنی بیکٹیریاکش دوائیں یا اسٹریپٹومائسن جیسی اینٹی بائیوٹکس استعمال کریں۔ غیر میزبان فصلوں کے ساتھ فصل کی گردش کریں۔ متاثرہ پودوں کے ملبے کو ہٹائیں اور تلف کریں۔',
      ),
      severity: 'High',
      symptoms: [
        DiseaseTranslation(
          english: 'Angular water-soaked spots on leaves',
          urdu: 'پتوں پر کونیی پانی بھرے دھبے',
        ),
        DiseaseTranslation(
          english: 'Black or brown lesions on bolls',
          urdu: 'پھلیوں پر کالے یا بھورے زخم',
        ),
        DiseaseTranslation(
          english: 'Leaf yellowing and defoliation',
          urdu: 'پتوں کا پیلا ہونا اور گرنا',
        ),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Use resistant cotton varieties',
          urdu: 'مزاحم کپاس کی اقسام استعمال کریں',
        ),
        DiseaseTranslation(
          english: 'Maintain proper plant spacing for air circulation',
          urdu: 'ہوا کی گردش کے لیے مناسب پودوں کا فاصلہ برقرار رکھیں',
        ),
        DiseaseTranslation(
          english: 'Avoid overhead irrigation',
          urdu: 'اوپر سے آبپاشی سے پرہیز کریں',
        ),
      ],
    ),
    'cotton_curl_virus': DiseaseInfo(
      id: 'cotton_curl_virus',
      name: DiseaseTranslation(english: 'Cotton Leaf Curl Virus', urdu: 'کاٹن لیف کرل وائرس'),
      description: DiseaseTranslation(
        english:
            'A viral disease transmitted by whiteflies causing severe leaf curling, vein thickening, and stunted growth. One of the most devastating diseases for cotton in Pakistan.',
        urdu:
            'سفید مکھیوں کے ذریعے منتقل ہونے والی وائرل بیماری جو شدید پتوں کے مڑنے، رگوں کے موٹا ہونے اور نشوونما میں رکاوٹ کا سبب بنتی ہے۔ پاکستان میں کپاس کے لیے سب سے تباہ کن بیماریوں میں سے ایک۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Control whitefly vectors using approved insecticides like imidacloprid or acetamiprid. Remove and destroy infected plants immediately. Use virus-resistant cotton varieties. Apply neem oil as organic control.',
        urdu:
            'منظور شدہ کیڑے مار ادویات جیسے امیڈاکلوپرڈ یا ایسیٹامپرڈ استعمال کرتے ہوئے سفید مکھیوں پر قابو پائیں۔ متاثرہ پودوں کو فوری طور پر ہٹائیں اور تلف کریں۔ وائرس مزاحم کپاس کی اقسام استعمال کریں۔ نامیاتی کنٹرول کے طور پر نیم کا تیل لگائیں۔',
      ),
      severity: 'Critical',
      symptoms: [
        DiseaseTranslation(
          english: 'Upward and downward curling of leaves',
          urdu: 'پتوں کا اوپر اور نیچے کی طرف مڑنا',
        ),
        DiseaseTranslation(
          english: 'Thickening and darkening of leaf veins',
          urdu: 'پتوں کی رگوں کا موٹا اور سیاہ ہونا',
        ),
        DiseaseTranslation(
          english: 'Severely stunted plant growth',
          urdu: 'پودوں کی نشوونما میں شدید رکاوٹ',
        ),
        DiseaseTranslation(english: 'Reduced boll formation', urdu: 'پھلیوں کی تشکیل میں کمی'),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Plant virus-resistant varieties (e.g., BT cotton)',
          urdu: 'وائرس مزاحم اقسام لگائیں (مثلاً، BT کپاس)',
        ),
        DiseaseTranslation(
          english: 'Monitor and control whitefly population regularly',
          urdu: 'سفید مکھیوں کی آبادی کی باقاعدگی سے نگرانی اور کنٹرول کریں',
        ),
        DiseaseTranslation(
          english: 'Follow recommended planting dates',
          urdu: 'تجویز کردہ بوائی کی تاریخوں پر عمل کریں',
        ),
      ],
    ),
    'cotton_fussarium_wilt': DiseaseInfo(
      id: 'cotton_fussarium_wilt',
      name: DiseaseTranslation(english: 'Cotton Fusarium Wilt', urdu: 'کاٹن فیوزیریم وِلٹ'),
      description: DiseaseTranslation(
        english:
            'A soil-borne fungal disease causing wilting, yellowing of leaves, and vascular browning. The fungus can survive in soil for many years.',
        urdu:
            'مٹی سے پیدا ہونے والی فنگل بیماری جو مرجھانے، پتوں کے پیلے ہونے اور عروقی بھورے پن کا سبب بنتی ہے۔ فنگس کئی سالوں تک مٹی میں زندہ رہ سکتی ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Use resistant cotton varieties. Apply biological control agents like Trichoderma. Soil solarization during summer. Maintain proper soil pH and nutrition. Use fungicides containing carbendazim as preventive measure.',
        urdu:
            'مزاحم کپاس کی اقسام استعمال کریں۔ ٹرائیکوڈرما جیسے حیاتیاتی کنٹرول ایجنٹ لگائیں۔ گرمیوں میں مٹی کی شمسی توانائی۔ مناسب مٹی کا پی ایچ اور غذائیت برقرار رکھیں۔ احتیاطی تدبیر کے طور پر کاربینڈازم پر مشتمل فنگسائڈ استعمال کریں۔',
      ),
      severity: 'High',
      symptoms: [
        DiseaseTranslation(
          english: 'Wilting of plants during day, recovery at night',
          urdu: 'دن کے وقت پودوں کا مرجھانا، رات کو بحالی',
        ),
        DiseaseTranslation(
          english: 'Yellowing of lower leaves progressing upward',
          urdu: 'نچلے پتوں کا پیلا ہونا جو اوپر کی طرف بڑھتا ہے',
        ),
        DiseaseTranslation(
          english: 'Brown discoloration of vascular tissue',
          urdu: 'عروقی بافتوں کا بھورا رنگ',
        ),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Crop rotation with non-susceptible crops',
          urdu: 'غیر حساس فصلوں کے ساتھ فصل کی گردش',
        ),
        DiseaseTranslation(
          english: 'Avoid water stress and maintain balanced nutrition',
          urdu: 'پانی کی کمی سے بچیں اور متوازن غذائیت برقرار رکھیں',
        ),
        DiseaseTranslation(
          english: 'Use disease-free seeds and clean equipment',
          urdu: 'بیماری سے پاک بیج اور صاف آلات استعمال کریں',
        ),
      ],
    ),
    'cotton_healthy': DiseaseInfo(
      id: 'cotton_healthy',
      name: DiseaseTranslation(english: 'Healthy Cotton', urdu: 'صحت مند کپاس'),
      description: DiseaseTranslation(
        english:
            'Congratulations! No disease detected. Your cotton plant appears healthy with normal growth and development.',
        urdu:
            'مبارک ہو! کوئی بیماری کا پتہ نہیں چلا۔ آپ کا کپاس کا پودا صحت مند دکھائی دیتا ہے اور عام نشوونما اور ترقی کر رہا ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Continue regular care: Maintain proper irrigation schedule. Apply balanced fertilizers (NPK). Monitor for pests regularly. Ensure adequate spacing between plants. Practice good field sanitation.',
        urdu:
            'باقاعدہ دیکھ بھال جاری رکھیں: مناسب آبپاشی کا شیڈول برقرار رکھیں۔ متوازن کھاد (NPK) ڈالیں۔ باقاعدگی سے کیڑوں کی نگرانی کریں۔ پودوں کے درمیان مناسب فاصلہ یقینی بنائیں۔ اچھی کھیت کی صفائی کا عمل کریں۔',
      ),
      severity: 'None',
      symptoms: [
        DiseaseTranslation(english: 'Healthy green leaves', urdu: 'صحت مند سبز پتے'),
        DiseaseTranslation(english: 'Normal growth and development', urdu: 'عام نشوونما اور ترقی'),
        DiseaseTranslation(english: 'Good boll formation', urdu: 'اچھی پھلیوں کی تشکیل'),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Regular monitoring for early disease detection',
          urdu: 'بیماری کی جلد تشخیص کے لیے باقاعدہ نگرانی',
        ),
        DiseaseTranslation(
          english: 'Maintain optimal soil moisture',
          urdu: 'زمین میں بہترین نمی برقرار رکھیں',
        ),
        DiseaseTranslation(
          english: 'Follow integrated pest management practices',
          urdu: 'مربوط کیڑوں کے انتظام کے طریقوں پر عمل کریں',
        ),
      ],
    ),
    'wheat_brown_rust': DiseaseInfo(
      id: 'wheat_brown_rust',
      name: DiseaseTranslation(
        english: 'Wheat Brown Rust (Leaf Rust)',
        urdu: 'گندم براؤن رسٹ (پتی کا زنگ)',
      ),
      description: DiseaseTranslation(
        english:
            'A fungal disease characterized by orange-brown pustules on wheat leaves. It can cause significant yield losses if not controlled early.',
        urdu:
            'فنگل بیماری جس کی خصوصیت گندم کے پتوں پر نارنجی بھورے پھوڑوں سے ہوتی ہے۔ اگر جلد کنٹرول نہ کیا جائے تو یہ پیداوار میں نمایاں نقصان کا سبب بن سکتی ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Apply fungicides like propiconazole, tebuconazole, or mancozeb at first sign of disease. Use resistant wheat varieties. Remove crop residues after harvest. Spray at 10-15 day intervals if disease persists.',
        urdu:
            'بیماری کی پہلی علامت پر پروپیکونازول، ٹیبوکونازول، یا مانکوزیب جیسے فنگسائڈ لگائیں۔ مزاحم گندم کی اقسام استعمال کریں۔ فصل کی کٹائی کے بعد باقیات کو ہٹا دیں۔ اگر بیماری برقرار رہے تو 10-15 دن کے وقفے سے سپرے کریں۔',
      ),
      severity: 'Medium',
      symptoms: [
        DiseaseTranslation(
          english: 'Small orange-brown pustules on leaves',
          urdu: 'پتوں پر چھوٹے نارنجی بھورے پھوڑے',
        ),
        DiseaseTranslation(
          english: 'Premature yellowing of leaves',
          urdu: 'پتوں کا وقت سے پہلے پیلا ہونا',
        ),
        DiseaseTranslation(english: 'Reduced grain filling', urdu: 'دانے کی بھرائی میں کمی'),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Plant rust-resistant wheat varieties',
          urdu: 'زنگ مزاحم گندم کی اقسام لگائیں',
        ),
        DiseaseTranslation(english: 'Avoid late sowing', urdu: 'دیر سے بوائی سے پرہیز کریں'),
        DiseaseTranslation(
          english: 'Maintain balanced nitrogen application',
          urdu: 'متوازن نائٹروجن کا اطلاق برقرار رکھیں',
        ),
      ],
    ),
    'wheat_healthy': DiseaseInfo(
      id: 'wheat_healthy',
      name: DiseaseTranslation(english: 'Healthy Wheat', urdu: 'صحت مند گندم'),
      description: DiseaseTranslation(
        english:
            'Excellent! No disease detected. Your wheat crop is healthy and showing good growth characteristics.',
        urdu:
            'بہترین! کوئی بیماری کا پتہ نہیں چلا۔ آپ کی گندم کی فصل صحت مند ہے اور اچھی نشوونما کی خصوصیات دکھا رہی ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Continue good agricultural practices: Irrigate at critical growth stages (tillering, jointing, flowering). Apply nitrogen in split doses. Keep fields weed-free. Monitor for pests and diseases regularly.',
        urdu:
            'اچھے زرعی طریقوں کو جاری رکھیں: اہم نشوونما کے مراحل پر آبپاشی کریں (شاخوں کا بننا، جوڑوں کا بننا، پھول آنا)۔ تقسیم شدہ خوراکوں میں نائٹروجن ڈالیں۔ کھیتوں کو جڑی بوٹیوں سے پاک رکھیں۔ باقاعدگی سے کیڑوں اور بیماریوں کی نگرانی کریں۔',
      ),
      severity: 'None',
      symptoms: [
        DiseaseTranslation(english: 'Dark green healthy leaves', urdu: 'گہرے سبز صحت مند پتے'),
        DiseaseTranslation(
          english: 'Good tillering and plant vigor',
          urdu: 'اچھی شاخوں کا بننا اور پودے کی طاقت',
        ),
        DiseaseTranslation(english: 'Normal spike development', urdu: 'عام بالیوں کی نشوونما'),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Scout fields regularly for early problem detection',
          urdu: 'ابتدائی مسائل کی تشخیص کے لیے باقاعدگی سے کھیتوں کی نگرانی کریں',
        ),
        DiseaseTranslation(
          english: 'Ensure proper drainage to avoid waterlogging',
          urdu: 'پانی جمع ہونے سے بچنے کے لیے مناسب نکاسی آب کو یقینی بنائیں',
        ),
        DiseaseTranslation(
          english: 'Apply micronutrients if deficiency symptoms appear',
          urdu: 'اگر کمی کی علامات ظاہر ہوں تو مائیکرو نیوٹرینٹس ڈالیں',
        ),
      ],
    ),
    'wheat_loose_smut': DiseaseInfo(
      id: 'wheat_loose_smut',
      name: DiseaseTranslation(english: 'Wheat Loose Smut', urdu: 'گندم لوز سمٹ'),
      description: DiseaseTranslation(
        english:
            'A seed-borne fungal disease that replaces grain with masses of black spores. The disease spreads through infected seeds.',
        urdu:
            'بیج سے پیدا ہونے والی فنگل بیماری جو دانے کو کالے بیضوں کی بڑی تعداد سے بدل دیتی ہے۔ یہ بیماری متاثرہ بیجوں کے ذریعے پھیلتی ہے۔',
      ),
      treatment: DiseaseTranslation(
        english:
            'Use certified disease-free seeds. Treat seeds with systemic fungicides like carboxin or tebuconazole before sowing. Hot water seed treatment (52°C for 11 minutes) is effective. Remove and destroy infected plants during field inspection.',
        urdu:
            'تصدیق شدہ بیماری سے پاک بیج استعمال کریں۔ بوائی سے پہلے بیجوں کو کاربوکسین یا ٹیبوکونازول جیسے سسٹمک فنگسائڈ سے علاج کریں۔ گرم پانی سے بیج کا علاج (52°C 11 منٹ کے لیے) مؤثر ہے۔ کھیت کے معائنے کے دوران متاثرہ پودوں کو ہٹا کر تلف کریں۔',
      ),
      severity: 'High',
      symptoms: [
        DiseaseTranslation(
          english: 'Spikes completely filled with black spore mass',
          urdu: 'بالیں مکمل طور پر کالے بیضوں کے ماس سے بھری ہوئی',
        ),
        DiseaseTranslation(
          english: 'Infected heads emerge earlier than healthy ones',
          urdu: 'متاثرہ بالیں صحت مند بالیوں سے پہلے نکلتی ہیں',
        ),
        DiseaseTranslation(
          english: 'Spores released leaving bare rachis',
          urdu: 'بیضے خارج ہو کر ننگی شاخ چھوڑ دیتے ہیں',
        ),
      ],
      preventionTips: [
        DiseaseTranslation(
          english: 'Always use treated or certified seeds',
          urdu: 'ہمیشہ علاج شدہ یا تصدیق شدہ بیج استعمال کریں',
        ),
        DiseaseTranslation(
          english: 'Rogue out infected plants during crop growth',
          urdu: 'فصل کی نشوونما کے دوران متاثرہ پودوں کو نکال دیں',
        ),
        DiseaseTranslation(
          english: 'Use resistant wheat varieties when available',
          urdu: 'جب دستیاب ہوں تو مزاحم گندم کی اقسام استعمال کریں',
        ),
      ],
    ),
  };
}
