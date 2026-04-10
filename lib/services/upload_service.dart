import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadService {
  // 1. Paste your ENTIRE master JSON array right here inside the triple quotes!
  static const List<Map<String, dynamic>> exercises = [
    {
      "id": "ankle_001",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "twMbBmHwso",
      "titles": {
        "en": "Ankle Pumps (Flexion/Extension)",
        "hi": "एंकल पंप्स (फ्लेक्सन/एक्सटेंशन)",
        "gu": "પગની ઘૂંટીના પંપ (ફ્લેક્સન/એક્સટેન્શન)"
      },
      "descriptions": {
        "en": "Sit with legs straight. Point your toes away from you, then pull them back toward your shins.",
        "hi": "सीधे पैर करके बैठें। अपने पंजों को खुद से दूर करें, फिर उन्हें वापस अपनी पिंडलियों की ओर खींचें।",
        "gu": "પગ સીધા રાખીને બેસો. તમારા પંજાને તમારાથી દૂર કરો, પછી તેમને તમારા નળા (શિન) તરફ પાછા ખેંચો."
      },
      "targetSymptoms": ["Swelling", "Stiffness", "Post-Injury"],
      "clinicalBenefit": "Acts as a 'muscle pump' to reduce edema (swelling) and maintain basic joint mobility.",
      "reps": "20",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Move within a pain-free range; do not force the end-range if shconst arp pain occurs."
    },
    {
      "id": "ankle_002",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "6XX3R9ibBfw",
      "titles": {
        "en": "Ankle Circles",
        "hi": "एंकल सर्कल्स",
        "gu": "પગની ઘૂંટીના વર્તુળો"
      },
      "descriptions": {
        "en": "Slowly rotate your foot in a large circle, moving only at the ankle joint.",
        "hi": "धीरे-धीरे अपने पैर को एक बड़े घेरे में घुमाएं, केवल टखने के जोड़ को हिलाएं।",
        "gu": "ધીમે ધીમે તમારા પગને મોટા વર્તુળમાં ફેરવો, માત્ર પગની ઘૂંટીના સાંધાને હલાવો."
      },
      "targetSymptoms": ["Stiffness", "Clicking/Popping", "Limited Motion"],
      "clinicalBenefit": "Increases synovial fluid circulation and mobilizes the talocrural and subtalar joints.",
      "reps": "10 each way",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Ensure the movement coconst mes from the ankle, not the knee or hip."
    },
    {
      "id": "ankle_003",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "YTVZUMuEKPA",
      "titles": {
        "en": "Alphabet Trace",
        "hi": "अल्फाबेट ट्रेस",
        "gu": "મૂળાક્ષર ટ્રેસ"
      },
      "descriptions": {
        "en": "Imagine your big toe is a pen. Trace the letters of the alphabet (A-Z) in the air.",
        "hi": "कल्पना करें कि आपके पैर का अंगूठा एक पेन है। हवा में वर्णमाला के अक्षर (A-Z) लिखें।",
        "gu": "કલ્પના કરો કે તમારા પગનો અંગૂઠો એક પેન છે. હવામાં મૂળાક્ષરોના અક્ષરો (A-Z) લખો."
      },
      "targetSymptoms": ["Limited Motion", "Coordination Issues"],
      "clinicalBenefit": "Promotes multi-planar mobility and neuromuscular control.",
      "reps": "1 set (A-Z)",
      "sets": "1",
      "holdTime": "N/A",
       "caution": "Keep the leg still; only move the foot and ankle."
    },
    {
      "id": "ankle_004",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "wFql2AxI8PQ",
      "titles": {
        "en": "Towel Scrunches",
        "hi": "तौलिया स्क्रंचेस",
        "gu": "ટુવાલ સ્ક્રેન્ચ્સ"
      },
      "descriptions": {
        "en": "Place a towel on the floor. Use only your toes to pull the towel toward you.",
        "hi": "फर्श पर एक तौलिया रखें। तौलिये को अपनी ओर खींचने के लिए केवल अपने पैर की उंगलियों का उपयोग करें।",
        "gu": "ફ્લોર પર ટુવાલ મૂકો. ટુવાલને તમારી તરફ ખેંચવા માટે માત્ર તમારા પગના અંગૂઠાનો ઉપયોગ કરો."
      },
      "targetSymptoms": ["Weakness", "Flat Feet", "Arch Pain"],
      "clinicalBenefit": "Strengthens the intrinsic muscles of the foot and the tibialis posterior for arch support.",
      "reps": "10",
      "sets": "2",
      "holdTimeconst ": "3 seconds",
      "caution": "Do not lift your heel off the floor while scrunching."
    },
    {
      "id": "ankle_005",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "mafo7o7OnFo",
      "titles": {
        "en": "Standing Calf Stretch (Gastrocnemius)",
        "hi": "स्टैंडिंग काफ स्ट्रेच",
        "gu": "સ્ટેન્ડિંગ કાફ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Stand facing a wall with one foot back, heel flat, and knee straight. Lean forward until a stretch is felt in the calf.",
        "hi": "एक पैर पीछे, एड़ी सपाट और घुटना सीधा करके दीवार की ओर मुंह करके खड़े हों। पिंडली में खिंचाव महसूस होने तक आगे झुकें।",
        "gu": "એક પગ પાછળ, એડી સપાટ અને ઘૂંટણ સીધો રાખીને દીવાલ તરફ મોઢું રાખીને ઉભા રહો. પિંડીમાં ખેંચાણ અનુભવાય ત્યાં સુધી આગળ નમો."
      },
      "targetSymptoms": ["Sharp Pain", "Tightness", "Achilles Pain"],
      "clinicalBenefit": "Relieves tension on the Achilles tendon and improves dorsiflexion.",
      "reps": "3 per side",
       "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Keep the back heel firmly on the ground."
    },
    {
      "id": "ankle_006",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "9qxc8eML0SA",
      "titles": {
        "en": "Soleus Stretch (Bent Knee)",
        "hi": "सोलियस स्ट्रेच (मुड़ा हुआ घुटना)",
        "gu": "સોલિયસ સ્ટ્રેચ (વળેલું ઘૂંટણ)"
      },
      "descriptions": {
        "en": "Similar to the calf stretch, but slightly bend the back knee while keeping the heel on the floor.",
        "hi": "पिंडली के खिंचाव के समान, लेकिन एड़ी को फर्श पर रखते हुए पिछले घुटने को थोड़ा मोड़ें।",
        "gu": "કાફ સ્ટ્રેચ જેવું જ, પણ એડી જમીન પર રાખીને પાછળના ઘૂંટણને સહેજ વાળો."
      },
      "targetSymptoms": ["Stiffness", "Heel Pain"],
      "clinicalBenefit": "Targets the deeper soleus muscle, which is essential for walking and absorbing shock.",
      "reps": "3 per side",
      "sets": "1",
       "holdTime": "30 seconds",
      "caution": "You will feel this lower down toward the heel compared to the standard calf stretch."
    },
    {
      "id": "ankle_007",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "g7MzQbhkMsU",
      "titles": {
        "en": "Isometric Eversion",
        "hi": "आइसोमेट्रिक एवर्जन",
        "gu": "આઇસોમેટ્રિક એવર્ઝન"
      },
      "descriptions": {
        "en": "Place the outside of your foot against a wall or table leg. Push outward into the object without moving your ankle.",
        "hi": "अपने पैर के बाहरी हिस्से को दीवार या मेज के पैर के सामने रखें। टखने को हिलाए बिना वस्तु पर बाहर की ओर दबाव डालें।",
        "gu": "તમારા પગની બહારની બાજુને દીવાલ અથવા ટેબલના પાયા સામે રાખો. ઘૂંટી હલાવ્યા વગર વસ્તુ પર બહારની તરફ દબાણ આપો."
      },
      "targetSymptoms": ["Instability", "Frequent Sprains"],
      "clinicalBenefit": "Strengthens the peroneal muscles, which prevent the ankle from 'rolling' inward.",
       "reps": "10",
      "sets": "3",
      "holdTime": "5 seconds",
      "caution": "Do not let the knee rotate; the force should come solely from the ankle."
    },
    {
      "id": "ankle_008",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "Dtgh2_LFkBQ",
      "titles": {
        "en": "Single-Leg Balance",
        "hi": "सिंगल-लेग बैलेंस",
        "gu": "સિંગલ-લેગ બેલેન્સ"
      },
      "descriptions": {
        "en": "Stand on the affected leg only. Try to maintain balance without holding onto anything.",
        "hi": "केवल प्रभावित पैर पर खड़े हों। बिना किसी सहारे के संतुलन बनाए रखने की कोशिश करें।",
        "gu": "માત્ર અસરગ્રસ્ત પગ પર ઉભા રહો. કોઈ પણ ટેકા વગર સંતુલન જાળવવાનો પ્રયાસ કરો."
      },
      "targetSymptoms": ["Instability", "Weakness", "Poor Balance"],
      "clinicalBenefit": "Improves proprioception (the brain's awareness of joint position) const to prevent re-injury.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30-60 seconds",
      "caution": "Perform near a wall or chair for safety in case you lose balance."
    },
    {
      "id": "ankle_009",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "rkf48wvb1_I",
      "titles": {
        "en": "Heel-to-Toe Walk (Tandem Walk)",
        "hi": "हील-टू-टो वॉक (टैंडम वॉक)",
        "gu": "હીલ-ટુ-ટો વૉક (ટેન્ડમ વૉક)"
      },
      "descriptions": {
        "en": "Walk in a straight line, placing the heel of one foot directly in front of the toes of the other.",
        "hi": "एक सीधी रेखा में चलें, एक पैर की एड़ी को दूसरे पैर की उंगलियों के ठीक सामने रखें।",
        "gu": "એક સીધી રેખામાં ચાલો, એક પગની એડીને બીજા પગના પંજાની બરાબર સામે રાખો."
      },
      "targetSymptoms": ["Instability", "Coordination Issues"],
      "clinicalBenefit": "Challenges dynamic stability and strengthens the stabiliconst zing muscles around the ankle.",
      "reps": "20 steps",
      "sets": "2",
      "holdTime": "Control-focused",
      "caution": "Look straight ahead rather than at your feet to increase the challenge."
    },
    {
      "id": "ankle_010",
      "targetBodyPart": "Ankle",
      "category": "Mobility, Balance & Ligament Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "5YUh4lOQ2pI",
      "titles": {
        "en": "Resisted Dorsiflexion",
        "hi": "रेसिस्टेड डॉर्सिफ्लेक्सन",
        "gu": "રેઝિસ્ટડ ડોર્સિફ્લેક્સન"
      },
      "descriptions": {
        "en": "Sit with leg straight. Loop a resistance band over the top of your foot and pull toward your shin.",
        "hi": "पैर सीधे करके बैठें। अपने पैर के ऊपरी हिस्से पर एक रेजिस्टेंस बैंड लूप करें और इसे अपनी पिंडली की ओर खींचें।",
        "gu": "પગ સીધા રાખીને બેસો. તમારા પગના ઉપરના ભાગે રેઝિસ્ટન્સ બેન્ડ ભીડાવો અને તેને તમારા નળા (શિન) તરફ ખેંચો."
      },
      "targetSymptoms": ["Weakness", "Difficulty Walking"],
      "clinicalBenefit": "Strengthens the Tibialis const Anterior, which helps with 'foot drop' and walking mechanics.",
      "reps": "15",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Ensure the movement is slow and controlled on the way back down."
    },

    //knee
    {
      "id": "knee_001",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "IF5eDfb8afM",
      "titles": {
        "en": "Quad Sets (Isometric Contraction)",
        "hi": "क्वाड सेट्स (मांसपेशियों का संकुचन)",
        "gu": "ક્વાડ સેટ્સ (સ્નાયુઓનું સંકોચન)"
      },
      "descriptions": {
        "en": "Sit with your leg straight. Tighten your thigh muscle by pushing the back of your knee down into the floor.",
        "hi": "पैर सीधा करके बैठें। अपने घुटने के पिछले हिस्से को फर्श की ओर नीचे दबाते हुए अपनी जांघ की मांसपेशियों को कस लें।",
        "gu": "પગ સીધો રાખીને બેસો. તમારા ઘૂંટણના પાછળના ભાગને જમીન તરફ નીચે દબાવીને તમારી સાથળના સ્નાયુઓને સજ્જડ કરો."
      },
      "targetSymptoms": ["Weakness", "Dull Ache", "Swelling"],
      "clinicalBenefit":  "Re-educates the quadriceps without placing stress on the knee joint; essential for post-injury recovery.",
      "reps": "10",
      "sets": "3",
      "holdTime": "5 seconds",
      "caution": "Do not hold your breath; focus on a hard, steady squeeze."
    },
    {
      "id": "knee_002",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "cL0uVeG6Zx8",
      "titles": {
        "en": "Short Arc Quads",
        "hi": "शॉर्ट आर्क क्वाड्स",
        "gu": "શોર્ટ આર્ક ક્વાડ્સ"
      },
      "descriptions": {
        "en": "Place a rolled towel under your knee. Lift your foot up until your leg is straight, then slowly lower it.",
        "hi": "अपने घुटने के नीचे एक मुड़ा हुआ तौलिया रखें। अपने पैर को तब तक ऊपर उठाएं जब तक कि पैर सीधा न हो जाए, फिर धीरे-धीरे इसे नीचे करें।",
        "gu": "તમારા ઘૂંટણની નીચે વીંટાળેલો ટુવાલ રાખો. પગ સીધો ન થાય ત્યાં સુધી તમારા પંજાને ઉપર ઉઠાવો, પછી તેને ધીમેથી નીચે કરો."
      },
      "targetSymptoms": ["Weakness", "Limited Motion", "Instaconst bility"],
      "clinicalBenefit": "Specifically targets the VMO, which is crucial for proper patellar (kneecap) tracking.",
      "reps": "15",
      "sets": "2",
      "holdTime": "3 seconds",
      "caution": "Keep the back of your knee pressed against the towel throughout."
    },
    {
      "id": "knee_003",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "Ka19yzAlIGY",
      "titles": {
        "en": "Straight Leg Raise (SLR)",
        "hi": "स्ट्रेट लेग रेज़",
        "gu": "સ્ટ્રેટ લેગ રેઝ (પગ ઊંચો કરવો)"
      },
      "descriptions": {
        "en": "Lie on your back with one knee bent. Keep the other leg straight and lift it to the height of the bent knee.",
        "hi": "एक घुटना मोड़कर अपनी पीठ के बल लेट जाएं। दूसरे पैर को सीधा रखें और उसे मुड़े हुए घुटने की ऊंचाई तक उठाएं।",
        "gu": "એક ઘૂંટણ વાળીને તમારી પીઠ પર સૂઈ જાઓ. બીજા પગને સીધો રાખો અને તેને વળેલા ઘૂંટણની ઊંચાઈ સુધી ઉઠાવો."
      },
       "targetSymptoms": ["Weakness", "Fatigue", "Instability"],
      "clinicalBenefit": "Strengthens the hip flexors and quads without bending the knee joint.",
      "reps": "10",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Keep your lower back flat on the floor; do not arch."
    },
    {
      "id": "knee_004",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "dXkL0muKCLo",
      "titles": {
        "en": "Wall Slides (Mini-Squats)",
        "hi": "वॉल स्लाइड्स (मिनी-स्क्वाट्स)",
        "gu": "વોલ સ્લાઇડ્સ (મિની-સ્ક્વોટ્સ)"
      },
      "descriptions": {
        "en": "Lean your back against a wall. Slowly slide down until knees are bent at 30-45 degrees, then slide back up.",
        "hi": "अपनी पीठ दीवार के सहारे टिकाएं। धीरे-धीरे नीचे की ओर स्लाइड करें जब तक कि घुटने 30-45 डिग्री तक न मुड़ जाएं, फिर वापस ऊपर स्लाइड करें।",
        "gu": "તમારી પીઠ દીવાલના ટેકે રાખો. ઘૂંટણ 30-45 ડિગ્રી સુધી ન વળે ત્યાં સુધી ધીમે ધીમે નીચે ઉતરો, પછી પાછા ઉપર સ્લાઇડ કરો."
      },
       "targetSymptoms": ["Dull Ache", "Weakness", "Stiffness"],
      "clinicalBenefit": "Functional weight-bearing exercise that strengthens the quads and glutes in a controlled range.",
      "reps": "12",
      "sets": "3",
      "holdTime": "3 seconds at bottom",
      "caution": "Ensure your knees do not go past your toes."
    },
    {
      "id": "knee_005",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "BL68tDXi430",
      "titles": {
        "en": "Heel Slides",
        "hi": "हील स्लाइड्स",
        "gu": "હીલ સ્લાઇડ્સ"
      },
      "descriptions": {
        "en": "Lie on your back. Slowly slide your heel toward your buttocks, bending your knee as far as comfortable.",
        "hi": "अपनी पीठ के बल लेट जाएं। धीरे-धीरे अपनी एड़ी को अपने नितंबों की ओर सरकाएं, अपने घुटने को जितना हो सके उतना मोड़ें।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ. ધીમે ધીમે તમારી એડીને તમારા નિતંબ તરફ સરકાવો, ઘૂંટણને બને તેટલો વconst ાળો."
      },
      "targetSymptoms": ["Stiffness", "Limited Motion", "Post-Op"],
      "clinicalBenefit": "Restores knee flexion range of motion while maintaining joint lubrication.",
      "reps": "10",
      "sets": "2",
      "holdTime": "5 seconds",
      "caution": "Use a towel under your heel if on a carpeted surface for smoother motion."
    },
    {
      "id": "knee_006",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "oWu8RxtWdGE",
      "titles": {
        "en": "Hamstring Curls (Standing)",
        "hi": "हैमस्ट्रिंग कर्ल्स (खड़े होकर)",
        "gu": "હેમસ્ટ્રિંગ કર્લ્સ (ઉભા રહીને)"
      },
      "descriptions": {
        "en": "Stand holding a chair for balance. Bend your knee and bring your heel toward your glutes.",
        "hi": "संतुलन के लिए कुर्सी पकड़कर खड़े हो जाएं। अपने घुटने को मोड़ें और अपनी एड़ी को अपने कूल्हों की ओर लाएं।",
        "gu": "સંતુલન માટે ખુરશી પકડીને ઉભા રહો. તમારા ઘૂંટણને વાળો અને const તમારી એડીને તમારા નિતંબ તરફ લાવો."
      },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Strengthens the hamstrings, which provide essential posterior support to the ACL.",
      "reps": "15 per side",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Keep your thighs aligned; do not let the working knee move forward."
    },
    {
      "id": "knee_007",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "wfhXnLILqdk",
      "titles": {
        "en": "Step-Ups",
        "hi": "स्टेप-अप्स",
        "gu": "સ્ટેપ-અપ્સ"
      },
      "descriptions": {
        "en": "Step up onto a low platform (6 inches) with the affected leg, then step back down slowly.",
        "hi": "प्रभावित पैर के साथ एक कम ऊंचे प्लेटफॉर्म (6 इंच) पर चढ़ें, फिर धीरे-धीरे वापस नीचे उतरें।",
        "gu": "અસરગ્રસ્ત પગ સાથે પ્લેટફોરconst ્મ (6 ઇંચ) પર ચઢો, પછી ધીમેથી પાછા નીચે ઉતરો."
      },
      "targetSymptoms": ["Weakness", "Difficulty with Stairs"],
      "clinicalBenefit": "Improves eccentric control and functional strength for daily activities.",
      "reps": "10 per side",
      "sets": "3",
      "holdTime": "Control-focused",
      "caution": "Do not use the trailing leg to 'push off'; let the top leg do the work."
    },
    {
      "id": "knee_008",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "tQ6pqITQx_Q",
      "titles": {
        "en": "Clamshells",
        "hi": "क्लैमशेल्स",
        "gu": "ક્લેમશેલ્સ"
      },
      "descriptions": {
        "en": "Lie on your side with knees bent. Keep your feet together and lift your top knee as high as possible.",
        "hi": "घुटनों को मोड़कर अपनी करवट के बल लेट जाएं। अपने पैरों को एक साथ रखें और अपने ऊपरी घुटने को जितना हो सके उतना ऊपर उठाएं।",
         "gu": "ઘૂંટણ વાળીને પડખે સૂઈ જાઓ. તમારા પગને એકસાથે રાખો અને ઉપરના ઘૂંટણને બને તેટલો ઉપર ઉઠાવો."
      },
      "targetSymptoms": ["Sharp Pain", "Kneecap Tracking Issues"],
      "clinicalBenefit": "Strengthens the Gluteus Medius to prevent valgus stress (knee caving in).",
      "reps": "15 per side",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Keep your hips stacked; do not roll backward."
    },
    {
      "id": "knee_009",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "",
      "titles": {
        "en": "Patellar Mobilization",
        "hi": "पेटेलर मोबिलाइज़ेशन (घुटने की हड्डी का संचलन)",
        "gu": "પટેલર મોબિલાઇઝેશન (ઘૂંટણની ઢીંચણીનું હલનચલન)"
      },
      "descriptions": {
        "en": "Sit with leg straight. Use your fingers to gently push your kneecap side-to-side and up-and-down.",
        "hi": "पैर सीधा करके बैठें। अपनी उंगलियों का उपयोग करके अपने घुटने की चक्की को धीरे से अगल-बगल और ऊपर-नीचे धकेलें।",
        "gu": "પગ સીધો રાconst ખીને બેસો. તમારી આંગળીઓનો ઉપયોગ કરીને ઢીંચણીને ધીમેથી આજુબાજુ અને ઉપર-નીચે ધકેલો."
      },
      "targetSymptoms": ["Clicking/Popping", "Stiffness"],
      "clinicalBenefit": "Reduces adhesions and improves the sliding mechanism of the patella.",
      "reps": "5 directions",
      "sets": "1",
      "holdTime": "5 seconds per push",
      "caution": "Keep your quad muscle completely relaxed; the kneecap won't move if the muscle is tight."
    },
    {
      "id": "knee_010",
      "targetBodyPart": "Knee",
      "category": "Patellar Tracking & Joint Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "",
      "titles": {
        "en": "Calf Raises",
        "hi": "काफ रेज़ेस",
        "gu": "કાફ રેઝેસ"
      },
      "descriptions": {
        "en": "Stand with feet hip-width apart. Rise onto the balls of your feet, then slowly lower.",
        "hi": "पैरों को कूल्हे की चौड़ाई में फैलाकर खड़े हों। अपने पंजों const के बल ऊपर उठें, फिर धीरे-धीरे नीचे आएं।",
        "gu": "પગ વચ્ચે જગ્યા રાખીને ઉભા રહો. પંજા પર ઉંચા થાઓ, પછી ધીમેથી નીચે ઉતરો."
      },
      "targetSymptoms": ["Fatigue", "Weakness"],
      "clinicalBenefit": "The calf muscles cross the knee joint; strengthening them improves overall stabilization.",
      "reps": "20",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Maintain balance; use a wall or chair for support if needed."
    },

    //wrist
    {
      "id": "wrist_001",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "XnJu70SLsJk",
      "titles": {
        "en": "Prayer Stretch",
        "hi": "प्रेयर स्ट्रेच",
        "gu": "પ્રેયર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place your palms together in front of your chest. Slowly lower your hands toward your waist while keeping palms pressed together until you feel a stretch.",
        "hi": "अपनी छाती के सामने अपनी हथेलियों को एक साथ रखें। हथेलियों को आपस में दबाते हुए धीरे-धीरे अपने हाथों को अपनी कमर की ओर नीचे करें जब तक कि आपको खिंचाव महसूस न हो।",
        "gu": "તમારી const છાતીની સામે તમારી હથેળીઓને એકસાથે જોડો. હથેળીઓને એકબીજા સાથે દબાવી રાખીને ધીમે ધીમે તમારા હાથને તમારી કમર તરફ નીચે કરો જ્યાં સુધી તમને ખેંચાણ અનુભવાય."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache", "Tightness"],
      "clinicalBenefit": "Stretches the wrist flexors and the transverse carpal ligament to relieve pressure in the carpal tunnel.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Do not let the heels of your hands pull apart."
    },
    {
      "id": "wrist_002",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "-CaG5vGE2lA",
      "titles": {
        "en": "Reverse Prayer Stretch",
        "hi": "रिवर्स प्रेयर स्ट्रेच",
        "gu": "રિવર્સ પ્રેયર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place the backs of your hands together in front of your chest with fingers pointing down. Slowly lower your elbows to increase the stretch.",
        "hi": "अपनी उंगलियों को नीचे की ओर रखते हुए अपने हाथों के पिछले हिस्सों को अपनी छाती के सामने एक साथ रखें। खिंचाव बढ़ाने के लिए धीरे-धीरे अपनconst ी कोहनियों को नीचे करें।",
        "gu": "તમારી આંગળીઓ નીચેની તરફ રાખીને તમારા હાથના પાછળના ભાગને તમારી છાતીની સામે એકસાથે જોડો. ખેંચાણ વધારવા માટે ધીમે ધીમે તમારી કોણીઓને નીચે કરો."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache"],
      "clinicalBenefit": "Targets the wrist extensors and the dorsal (top) aspect of the wrist joint capsule.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Avoid if you have acute inflammatory flare-ups on the back of the wrist."
    },
    {
      "id": "wrist_003",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "80Y3HHMgo6w",
      "titles": {
        "en": "Wrist Extension Stretch (Hand Down)",
        "hi": "रिस्ट एक्सटेंशन स्ट्रेच (हाथ नीचे)",
        "gu": "કાંડા એક્સ્ટેંશન સ્ટ્રેચ (હાથ નીચે)"
      },
      "descriptions": {
        "en": "Extend one arm with palm facing down. Use the other hand to gently pull the hand downward toward the floor.",
        "hi": "हथेली को नीचे की ओर रखते हुए एक हाथ फैलाएं। हाथ को धीरे से फर्श की ओर नीचconst े खींचने के लिए दूसरे हाथ का उपयोग करें।",
        "gu": "હથેળી નીચે તરફ રાખીને એક હાથ લંબાવો. હાથને ધીમેથી જમીન તરફ નીચે ખેંચવા માટે બીજા હાથનો ઉપયોગ કરો."
      },
      "targetSymptoms": ["Sharp Pain", "Tennis Elbow", "Tightness"],
      "clinicalBenefit": "Specifically targets the extensor carpi radialis muscles often strained by heavy mouse/keyboard use.",
      "reps": "3 per side",
      "sets": "1",
      "holdTime": "20-30 seconds",
      "caution": "Keep your elbow straight to ensure the stretch reaches the elbow attachment."
    },
    {
      "id": "wrist_004",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "f0RHZ6bnhxg",
      "titles": {
        "en": "Median Nerve Flossing",
        "hi": "मीडियन नर्व फ्लॉसिंग",
        "gu": "મીડિયન નર્વ ફ્લોસિંગ"
      },
      "descriptions": {
        "en": "Follow a sequence: Make a fist, straighten fingers, extend wrist back, move thumb away, rotate palm up, then gently pull thumb.",
        "hi": "एक क्रम का पालन करें: मुट्ठी बनाएं, उंगलियां सीधी करें, कलाई को पीछे फैलconst ाएं, अंगूठे को दूर ले जाएं, हथेली ऊपर घुमाएं, फिर अंगूठे को धीरे से खींचें।",
        "gu": "ક્રમ અનુસરો: મુઠ્ઠી વાળો, આંગળીઓ સીધી કરો, કાંડાને પાછળ ખેંચો, અંગૂઠો દૂર કરો, હથેળી ઉપર ફેરવો, પછી અંગૂઠાને ધીમેથી ખેંચો."
      },
      "targetSymptoms": ["Numbness", "Tingling", "Burning"],
      "clinicalBenefit": "Mobilizes the median nerve through the carpal tunnel to reduce 'tethering' and irritation.",
      "reps": "10",
      "sets": "1",
      "holdTime": "Flowing",
      "caution": "Do not hold the stretch; nerves require movement, not sustained tension."
    },
    {
      "id": "wrist_005",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "D4-jQu5GfBg",
      "titles": {
        "en": "Wrist Circles (Controlled)",
        "hi": "रिस्ट सर्कल्स (नियंत्रित)",
        "gu": "કાંડાના વર્તુળો (નિયંત્રિત)"
      },
      "descriptions": {
        "en": "Make a gentle fist. Slowly rotate your wrist in a full circle, focusing on making the circle as large as possible without pain.",
        "hi": "हल्की मुट्ठी बनाएं। धीरे-धीरे अपconst नी कलाई को पूरे घेरे में घुमाएं, बिना दर्द के घेरे को जितना संभव हो उतना बड़ा बनाने पर ध्यान दें।",
        "gu": "હળવી મુઠ્ઠી વાળો. તમારી કાંડાને ધીમે ધીમે સંપૂર્ણ વર્તુળમાં ફેરવો, દુખાવો થયા વિના વર્તુળને બને તેટલું મોટું બનાવવા પર ધ્યાન કેન્દ્રિત કરો."
      },
      "targetSymptoms": ["Clicking/Popping", "Stiffness"],
      "clinicalBenefit": "Increases synovial fluid production to lubricate the 8 small carpal bones.",
      "reps": "10 each direction",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Move slowly; avoid 'flicking' the wrist at the end of the range."
    },
    {
      "id": "wrist_006",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Intermediate",
      "maxPainScore": 4,
      "youtubeId": "grbacaaEwjg",
      "titles": {
        "en": "Tendon Gliding Exercises",
        "hi": "टेंडन ग्लाइडिंग एक्सरसाइज",
        "gu": "ટેન્ડન ગ્લાઈડિંગ કસરતો"
      },
      "descriptions": {
        "en": "Move fingers through 4 positions: Straight, Hook fist, Full fist, and Flat fist (fingertips to palm base).",
        "hconst i": "उंगलियों को 4 स्थितियों में ले जाएं: सीधी, हुक मुट्ठी, पूरी मुट्ठी और सपाट मुट्ठी (हथेली के आधार तक उंगलियां)।",
        "gu": "આંગળીઓને 4 સ્થિતિમાં ફેરવો: સીધી, હૂક મુઠ્ઠી, આખી મુઠ્ઠી અને સપાટ મુઠ્ઠી (હથેળીના નીચેના ભાગ સુધી આંગળીના ટેરવા)."
      },
      "targetSymptoms": ["Stiffness", "Weakness", "Limited Motion"],
      "clinicalBenefit": "Ensures the flexor tendons slide independently within their sheaths, preventing adhesions.",
      "reps": "10 cycles",
      "sets": "2",
      "holdTime": "2 seconds per position",
      "caution": "Perform with a relaxed wrist; do not force the fist closed."
    },
    {
      "id": "wrist_007",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "1gRPewE01Qs",
      "titles": {
        "en": "Ulnar Deviation (The Wave)",
        "hi": "उलनार डेविएशन (द वेव)",
        "gu": "અલનાર ડેવિએશન (ધ વેવ)"
      },
      "descriptions": {
        "en": "Place your forearm flat on a table with your hand on its side (pinky down). Move your hand up and down like you are hammeconst ring a nail.",
        "hi": "अपनी अग्रबाहु को मेज पर सपाट रखें और हाथ को उसकी तरफ (छोटी उंगली नीचे) रखें। अपने हाथ को ऊपर और नीचे हिलाएं जैसे आप कील ठोक रहे हों।",
        "gu": "તમારા હાથના આગળના ભાગને ટેબલ પર સપાટ રાખો અને હથેળીને બાજુ પર (ટચલી આંગળી નીચે) રાખો. તમારા હાથને ઉપર અને નીચે હલાવો જાણે તમે ખીલી ઠોકી રહ્યા હોવ."
      },
      "targetSymptoms": ["Sharp Pain", "Limited Motion"],
      "clinicalBenefit": "Improves lateral stability and mobility of the wrist, targeting the TFCC region.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Do not let your forearm lift off the table."
    },
    {
      "id": "wrist_008",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "H5qap5Ktrlk",
      "titles": {
        "en": "Thumb Opposition (Touch)",
        "hi": "थम्ब अपोजिशन (स्पर्श)",
        "gu": "થમ્બ ઓપોઝિશન (સ્પર્શ)"
      },
      "descriptions": {
        "en": "Touch the tip of your thumb to the tip of each finger, one bconst y one, forming an 'O' shape. Press slightly at each touch.",
        "hi": "अपने अंगूठे के सिरे को एक-एक करके प्रत्येक उंगली के सिरे से स्पर्श करें, जिससे 'O' आकार बने। प्रत्येक स्पर्श पर थोड़ा दबाव डालें।",
        "gu": "તમારા અંગૂઠાના ટેરવાને એક પછી એક દરેક આંગળીના ટેરવા સાથે સ્પર્શ કરો, 'O' આકાર બનાવો. દરેક સ્પર્શ પર સહેજ દબાણ આપો."
      },
      "targetSymptoms": ["Weakness", "Cramps"],
      "clinicalBenefit": "Strengthens the Thenar eminence (thumb base) and improves fine motor control.",
      "reps": "5 cycles",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Maintain a round circle; do not let the finger joints collapse."
    },
    {
      "id": "wrist_009",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Intermediate",
      "maxPainScore": 7,
      "youtubeId": "dsaOzSfsM24",
      "titles": {
        "en": "Eccentric Wrist Strengthening",
        "hi": "इसेंट्रिक रिस्ट स्ट्रेंथनिंग",
        "gu": "એક્સન્ટ્રિક કાંડા મજબૂતીકરણ"
      },
      "descriptions": {
        "en": "Hold a light weight. Use your healthy hand to lift it up, then use the afconst fected wrist to lower it very slowly (5 seconds).",
        "hi": "हल्का वजन पकड़ें। इसे ऊपर उठाने के लिए अपने स्वस्थ हाथ का उपयोग करें, फिर प्रभावित कलाई का उपयोग करके इसे बहुत धीरे-धीरे (5 सेकंड) नीचे करें।",
        "gu": "હળવું વજન પકડો. તેને ઉપર ઉઠાવવા માટે તમારા સ્વસ્થ હાથનો ઉપયોગ કરો, પછી અસરગ્રસ્ત કાંડાનો ઉપયોગ કરીને તેને ખૂબ જ ધીમેથી (5 સેકન્ડ) નીચે ઉતારો."
      },
      "targetSymptoms": ["Weakness", "Dull Ache"],
      "clinicalBenefit": "Rehabilitates chronic tendon issues by controlled loading of the muscle fibers.",
      "reps": "10",
      "sets": "3",
      "holdTime": "5 second lowering",
      "caution": "Only use the healthy hand for the 'lifting' phase."
    },
    {
      "id": "wrist_010",
      "targetBodyPart": "Wrist",
      "category": "Carpal Mobility & Nerve Gliding",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "iM-p8D1ErHg",
      "titles": {
        "en": "Ball Squeeze (Grip)",
        "hi": "बॉल स्क्वीज़ (पकड़)",
        "gu": "બોલ સ્ક્વીઝ (પકડ)"
      },
      "descriptions": {
        "en": "Hold a soft foam ball or rolled-up sock. Squeeze as hard as comfortable and hold.",
        "hi": "एक सॉफ्ट फोम बॉल या लिपटा हुआ मोजा पकड़ें। जितना आरामदायक हो उतना जोर से दबाएं और रोकें।",
        "gu": "સોફ્ટ ફોમ બોલ અથવા વીંટાળેલા મોજા પકડો. જેટલું અનુકૂળ હોય તેટલું જોરથી દબાવો અને પકડી રાખો."
      },
      "targetSymptoms": ["Weakness", "Fatigue"],
      "clinicalBenefit": "Improves functional strength of the forearm flexors and stabilizes the wrist joint.",
      "reps": "15",
      "sets": "3",
      "holdTime": "5 seconds",
      "caution": "Release slowly; do not snap the hand open."
    },
    {
      "id": "arm_001",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "_uINTR_7X-g",
      "titles": {
        "en": "Wrist Extensor Stretch",
        "hi": "रिस्ट एक्सटेंसर स्ट्रेच",
        "gu": "કાંડા એક્સ્ટેન્સર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Extend your arm const forward with the palm down. Use your other hand to gently pull your hand downward toward your body.",
        "hi": "हथेली नीचे की ओर रखते हुए अपने हाथ को आगे फैलाएं। अपने दूसरे हाथ का उपयोग करके अपने हाथ को धीरे से अपने शरीर की ओर नीचे खींचें।",
        "gu": "હથેળી નીચે તરફ રાખીને તમારા હાથને આગળ લંબાવો. તમારા બીજા હાથનો ઉપયોગ કરીને તમારા હાથને ધીમેથી તમારા શરીર તરફ નીચે ખેંચો."
      },
      "targetSymptoms": ["Sharp Pain", "Stiffness", "Tennis Elbow"],
      "clinicalBenefit": "Stretches the extensor carpi radialis muscles to relieve Lateral Epicondylitis.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Keep the elbow straight but not locked; do not pull to the point of pain."
    },
    {
      "id": "arm_002",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "i-JV2PsFzWA",
      "titles": {
        "en": "Wrist Flexor Stretch",
        "hi": "रिस्ट फ्लेक्सर स्ट्रेच",
        "gu": "કાંડા ફ્લેક્સર સ્ટ્રેચ"
      },
      "desconst criptions": {
        "en": "Extend your arm forward with the palm up. Use your other hand to gently pull your fingers and hand downward.",
        "hi": "हथेली ऊपर की ओर रखते हुए अपने हाथ को आगे फैलाएं। अपने दूसरे हाथ का उपयोग करके अपनी उंगलियों और हाथ को धीरे से नीचे की ओर खींचें।",
        "gu": "હથેળી ઉપર તરફ રાખીને તમારા હાથને આગળ લંબાવો. તમારા બીજા હાથનો ઉપયોગ કરીને તમારી આંગળીઓ અને હાથને ધીમેથી નીચેની તરફ ખેંચો."
      },
      "targetSymptoms": ["Dull Ache", "Stiffness", "Golfer's Elbow"],
      "clinicalBenefit": "Targets the flexor tendons on the inside of the elbow and forearm.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Ensure the stretch is felt in the forearm, not just the wrist joint."
    },
    {
      "id": "arm_003",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "nZHS1gWMc6I",
      "titles": {
        "en": "Forearm Pronation/Supination",
        "hi": "फोरआर्म प्रोनेशन/सुपिनेशन",
        "gu": "આગળના હાથનું રોટેશન (પ્રોનેશન/સુપિનેશન)"
      },
      "descriptions": {
        "en": "Sit with your forearm supported on a table, hand hanging off. Slowly rotate your palm to face the ceiling, then the floor.",
        "hi": "मेज पर अपनी अग्रबाहु को सहारा देकर बैठें, हाथ बाहर लटका हुआ हो। अपनी हथेली को धीरे-धीरे छत की ओर, फिर फर्श की ओर घुमाएं।",
        "gu": "ટેબલ પર તમારા હાથના આગળના ભાગને ટેકવીને બેસો, હાથ બહાર લટકતો રાખો. તમારી હથેળીને ધીમે ધીમે છત તરફ, પછી જમીન તરફ ફેરવો."
      },
      "targetSymptoms": ["Limited Motion", "Weakness", "Clicking/Popping"],
      "clinicalBenefit": "Improves the rotational range of the proximal and distal radioulnar joints.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Move only the forearm; do not let your shoulder or elbow lift."
    },
    {
      "id": "arm_004",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "Qtv7XHinNjg",
      "titles": {
        "en": "Wrist Radial/Ulnar Deviation",
        "hi": "रिस्ट रेडियल/उconst लनार डेविएशन",
        "gu": "કાંડાનું સાઇડ હલનચલન (રેડિયલ/અલનાર ડેવિએશન)"
      },
      "descriptions": {
        "en": "Place your forearm flat on a table. Wave your hand slowly side-to-side (like a windshield wiper) without moving the arm.",
        "hi": "अपनी अग्रबाहु को मेज पर सपाट रखें। हाथ हिलाए बिना अपने हाथ को धीरे-धीरे अगल-बगल (वाइपर की तरह) हिलाएं।",
        "gu": "તમારા હાથના આગળના ભાગને ટેબલ પર સપાટ રાખો. હાથ હલાવ્યા વગર તમારા પંજાને ધીમે ધીમે આજુબાજુ (વાઈપરની જેમ) ફેરવો."
      },
      "targetSymptoms": ["Sharp Pain", "Limited Motion", "Wrist Stiffness"],
      "clinicalBenefit": "Increases lateral mobility of the carpal bones.",
      "reps": "10 each side",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Keep your palm flat against the table surface."
    },
    {
      "id": "arm_005",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "UnkSHg0L4yM",
      "titles": {
        "en": "Median Nerve Glide",
        "hi": "मीडियन नर्व ग्लाइड",
        "gu": "મીડિયનconst  નર્વ ગ્લાઈડ"
      },
      "descriptions": {
        "en": "Make a fist, then straighten fingers, then extend your wrist back, then move your thumb away. Follow a rhythmic flow.",
        "hi": "मुट्ठी बनाएं, फिर उंगलियां सीधी करें, फिर कलाई को पीछे की ओर फैलाएं, फिर अंगूठे को दूर ले जाएं। एक लयबद्ध प्रवाह का पालन करें।",
        "gu": "મુઠ્ઠી વાળો, પછી આંગળીઓ સીધી કરો, પછી કાંડાને પાછળની તરફ ખેંચો, પછી અંગૂઠાને દૂર કરો. એક લયબદ્ધ રીતે આ પ્રક્રિયા કરો."
      },
      "targetSymptoms": ["Numbness", "Tingling", "Burning"],
      "clinicalBenefit": "Physiotherapy 'flossing' to reduce pressure on the median nerve (Carpal Tunnel relief).",
      "reps": "10",
      "sets": "1",
      "holdTime": "Flowing",
      "caution": "Nerves do not like to be stretched; keep the movement gentle and stop if tingling increases."
    },
    {
      "id": "arm_006",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Intermediate",
      "maxPainScore": 7,
      "youtubeId": "dsaOzSfsM24",
      "titles": {
        "en": "Eccentric Wrist Extension",
        "hi": "इसेंट्रिक रिस्ट एक्सटेंशन",
        "gu": "એક્સન્ટ્રિક કાંડા એક્સ્ટેંશનconst "
      },
      "descriptions": {
        "en": "Support your arm on a table, palm down. Use the healthy hand to lift the wrist up, then slowly lower it back down over 5 seconds.",
        "hi": "हथेली नीचे की ओर करके अपने हाथ को मेज पर टिकाएं। कलाई को ऊपर उठाने के लिए स्वस्थ हाथ का उपयोग करें, फिर 5 सेकंड में इसे धीरे-धीरे नीचे करें।",
        "gu": "હથેળી નીચે રાખીને તમારા હાથને ટેબલ પર ટેકવો. કાંડાને ઉપર ઉઠાવવા માટે બીજા સારા હાથનો ઉપયોગ કરો, પછી 5 સેકન્ડમાં તેને ધીમે ધીમે નીચે ઉતારો."
      },
      "targetSymptoms": ["Weakness", "Chronic Pain", "Tennis Elbow"],
      "clinicalBenefit": "The gold standard for tendon rehab; eccentric loading strengthens the tendon fibers.",
      "reps": "10",
      "sets": "3",
      "holdTime": "5 second lowering",
      "caution": "The 'lowering' phase is the most important part of this exercise."
    },
    {
      "id": "arm_007",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "Wqlncahg6VQ",
      "titles": {
        "en": "Fist Clench (Grip Strengthening)",
        "hi": "फिस्ट क्लेंच (पकड़ मजबूत करना)",
        "gu": "મુઠ્ઠી વાળવી (પકડ મજબૂત કરવી)"
      },
      "descriptions": {
        "en": "Grip a soft stress ball or rolled-up towel. Squeeze firmly, hold, and release.",
        "hi": "एक सॉफ्ट स्ट्रेस बॉल या लिपटे हुए तौलिये को पकड़ें। मजबूती से दबाएं, रोकें और छोड़ दें।",
        "gu": "સોફ્ટ સ્ટ્રેસ બોલ અથવા વીંટાળેલા ટુવાલને પકડો. મજબૂતીથી દબાવો, પકડી રાખો અને છોડી દો."
      },
      "targetSymptoms": ["Weakness", "Fatigue"],
      "clinicalBenefit": "Improves functional grip strength and blood flow to the forearm muscles.",
      "reps": "20",
      "sets": "2",
      "holdTime": "3 seconds",
      "caution": "Do not over-squeeze if you have acute inflammatory arthritis."
    },
    {
      "id": "arm_008",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "XnJu70SLsJk",
      "ticonst tles": {
        "en": "Prayer Stretch",
        "hi": "प्रेयर स्ट्रेच (प्रार्थना मुद्रा)",
        "gu": "પ્રેયર સ્ટ્રેચ (પ્રાર્થના મુદ્રા)"
      },
      "descriptions": {
        "en": "Place palms together in front of your chest. Slowly lower your hands toward your waist until you feel a stretch in the wrists.",
        "hi": "अपनी छाती के सामने हथेलियों को एक साथ रखें। अपने हाथों को धीरे-धीरे अपनी कमर की ओर नीचे करें जब तक कि कलाइयों में खिंचाव महसूस न हो।",
        "gu": "તમારી છાતીની સામે હથેળીઓને એકસાથે જોડો. તમારા હાથને ધીમે ધીમે તમારી કમર તરફ નીચે કરો જ્યાં સુધી કાંડામાં ખેંચાણ અનુભવાય."
      },
      "targetSymptoms": ["Tightness", "Wrist Pain"],
      "clinicalBenefit": "Provides a bilateral stretch to the wrist flexors and palmar fascia.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Keep your palms pressed firmly together."
    },
    {
      "id": "arm_009",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
       "maxPainScore": 6,
      "youtubeId": "-CaG5vGE2lA",
      "titles": {
        "en": "Reverse Prayer Stretch",
        "hi": "रिवर्स प्रेयर स्ट्रेच",
        "gu": "રિવર્સ પ્રેયર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place the backs of your hands together in front of your chest. Slowly lift your elbows to increase the stretch.",
        "hi": "अपनी छाती के सामने अपने हाथों के पिछले हिस्से को एक साथ रखें। खिंचाव बढ़ाने के लिए धीरे-धीरे अपनी कोहनियों को ऊपर उठाएं।",
        "gu": "તમારી છાતીની સામે તમારા હાથના પાછળના ભાગને એકસાથે જોડો. ખેંચાણ વધારવા માટે ધીમે ધીમે તમારી કોણીઓને ઉપર ઉઠાવો."
      },
      "targetSymptoms": ["Tightness", "Wrist Pain"],
      "clinicalBenefit": "Stretches the wrist extensors and the dorsal aspect of the wrist joint.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Avoid if you have acute Carpal Tunnel inflammation."
    },
    {
      "id": "arm_010",
      "targetBodyPart": "Arms",
      "category": "Elbow, Forearm & Wrist Mobility",
      "level": "Beginner",
      "maxPconst ainScore": 5,
      "youtubeId": "20EUM0UowrY",
      "titles": {
        "en": "Finger Extensions (Rubber Band)",
        "hi": "फिंगर एक्सटेंशन (रबर बैंड के साथ)",
        "gu": "આંગળીઓનું ખેંચાણ (રબર બેન્ડ સાથે)"
      },
      "descriptions": {
        "en": "Place a rubber band around your fingers and thumb. Spread your fingers wide against the resistance.",
        "hi": "अपनी उंगलियों और अंगूठे के चारों ओर एक रबर बैंड रखें। प्रतिरोध के विरुद्ध अपनी उंगलियों को चौड़ा फैलाएं।",
        "gu": "તમારી આંગળીઓ અને અંગૂઠાની આસપાસ રબર બેન્ડ રાખો. બેન્ડના દબાણ સામે તમારી આંગળીઓને પહોળી ફેલાવો."
      },
      "targetSymptoms": ["Weakness", "Fatigue", "Cramping"],
      "clinicalBenefit": "Balances the forearm by strengthening the often-neglected finger extensor muscles.",
      "reps": "15",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Use a light band to start; focus on a full, wide spread of the fingers."
    },
    {
      "id": "shoulder_001",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "WRpvXxiaScA",
       "titles": {
        "en": "Pendulum Swings (Codman's)",
        "hi": "पेंडुलम स्विंग्स",
        "gu": "પેન્ડુલમ સ્વિંગ્સ"
      },
      "descriptions": {
        "en": "Lean forward resting one arm on a table. Let the painful arm hang down and swing it gently in small circles, then side-to-side.",
        "hi": "एक हाथ को मेज पर रखकर आगे की ओर झुकें। दर्द वाले हाथ को नीचे लटकने दें और उसे धीरे-धीरे छोटे घेरों में, फिर अगल-बगल घुमाएं।",
        "gu": "એક હાથને ટેબલ પર ટેકવીને આગળ નમો. દુખાવાવાળા હાથને નીચે લટકવા દો અને તેને ધીમેથી નાના વર્તુળોમાં અને પછી આજુબાજુ ફેરવો."
      },
      "targetSymptoms": ["Sharp Pain", "Limited Motion", "Stiffness"],
      "clinicalBenefit": "Uses gravity to distract the humerus from the glenoid, providing pain relief without muscle strain.",
      "reps": "20 circles each way",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Do not use your arm muscles to move; let the momentum of your body do the work."
    },
    {
      "id": "shoulder_002",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
       "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "CpDEEAfyNSA",
      "titles": {
        "en": "Wall Crawls (Finger Ladder)",
        "hi": "वॉल क्रॉल्स (फिंगर लैडर)",
        "gu": "વોલ ક્રોલ્સ (ફિંગર લેડર)"
      },
      "descriptions": {
        "en": "Stand facing a wall. Use your fingers to 'walk' up the wall as high as you can without significant pain.",
        "hi": "दीवार की ओर मुंह करके खड़े हों। अपनी उंगलियों का उपयोग करके दीवार पर जितना हो सके उतना ऊपर चढ़ें बिना किसी खास दर्द के।",
        "gu": "દીવાલ તરફ મોઢું રાખીને ઉભા રહો. તમારી આંગળીઓનો ઉપયોગ કરીને દીવાલ પર બને તેટલા ઉપર ચઢો (વધારે દુખાવો ન થાય ત્યાં સુધી)."
      },
      "targetSymptoms": ["Limited Motion", "Stiffness"],
      "clinicalBenefit": "Gradually increases shoulder flexion and abduction range of motion.",
      "reps": "5-10 crawls",
      "sets": "3",
      "holdTime": "5 seconds at top",
      "caution": "Do not arch your back to get higher; keep your spine neutral."
    },
    {
      "id": "shoulder_003",
      "targetBodyPart": "Shoulder",
      "category": "Rotatconst or Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "CEQMx4zFwYs",
      "titles": {
        "en": "Doorway Pectoral Stretch",
        "hi": "डोरवे पेक्टोरल स्ट्रेच",
        "gu": "ડોરવે પેક્ટોરલ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place your forearms on the doorframe with elbows at shoulder height. Gently lean forward through the door.",
        "hi": "अपनी अग्रबाहुओं को दरवाजे के फ्रेम पर रखें और कोहनियों को कंधे की ऊंचाई पर रखें। धीरे से दरवाजे के माध्यम से आगे झुकें।",
        "gu": "તમારી આગળની ભુજાઓને દરવાજાની ફ્રેમ પર રાખો અને કોણીઓને ખભાની ઊંચાઈએ રાખો. ધીમેથી દરવાજાની વચ્ચેથી આગળ નમો."
      },
      "targetSymptoms": ["Stiffness", "Rounded Shoulders", "Dull Ache"],
      "clinicalBenefit": "Opens the chest and reduces anterior pull on the shoulder joint, improving posture.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Stop if you feel tingling or numbness in your fingers."
    },
    {
      "id": "shoulder_004",
      "targetBodyPart": "Shoulder",
      "categoconst ry": "Rotator Cuff & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "9MYWtJgthRc",
      "titles": {
        "en": "Sleeper Stretch",
        "hi": "स्लीपर स्ट्रेच",
        "gu": "સ્લીપર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Lie on your affected side with shoulder and elbow at 90 degrees. Use your other hand to push your forearm down toward the bed.",
        "hi": "प्रभावित करवट पर लेट जाएं, कंधे और कोहनी 90 डिग्री पर रखें। दूसरे हाथ से अपनी अग्रबाहु को बिस्तर की ओर नीचे धकेलें।",
        "gu": "અસરગ્રસ્ત પડખે સૂઈ જાઓ, ખભા અને કોણી 90 ડિગ્રી પર રાખો. બીજા હાથનો ઉપયોગ કરીને તમારા હાથના નીચેના ભાગને પથારી તરફ નીચે ધકેલો."
      },
      "targetSymptoms": ["Limited Motion", "Stiffness", "Clicking/Popping"],
      "clinicalBenefit": "Targets the Posterior Capsule; essential for internal rotation deficits.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Push very gently; this is a sensitive joint capsule stretch."
    },
    {
      "id": "shouldconst er_005",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "WgmuiAS3SO8",
      "titles": {
        "en": "Isometric External Rotation",
        "hi": "आइसोमेट्रिक एक्सटर्नल रोटेशन",
        "gu": "આઇસોમેટ્રિક એક્સટર્નલ રોટેશન"
      },
      "descriptions": {
        "en": "Stand sideways to a wall. With elbow tucked at 90 degrees, press the back of your wrist into the wall.",
        "hi": "दीवार के बगल में खड़े हों। कोहनी को 90 डिग्री पर सटाकर रखें, अपनी कलाई के पिछले हिस्से को दीवार में दबाएं।",
        "gu": "દીવાલની બાજુમાં ઉભા રહો. કોણીને 90 ડિગ્રીએ દબાવી રાખો, તમારા કાંડાના પાછળના ભાગને દીવાલ પર દબાવો."
      },
      "targetSymptoms": ["Weakness", "Dull Ache", "Instability"],
      "clinicalBenefit": "Strengthens the Infraspinatus and Teres Minor without joint movement.",
      "reps": "10",
      "sets": "2",
      "holdTime": "5-10 seconds",
      "caution": "Keep your elbow glued to your side; do not let it flare out."
    },
    {
      "id": "shoulder_const 006",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "_Lw3jVL8jD0",
      "titles": {
        "en": "Isometric Internal Rotation",
        "hi": "आइसोमेट्रिक इंटरनल रोटेशन",
        "gu": "આઇસોમેટ્રિક ઇન્ટરનલ રોટેશન"
      },
      "descriptions": {
        "en": "Stand in a doorway. With elbow at 90 degrees, press your palm into the doorframe as if moving it toward your belly.",
        "hi": "दरवाजे पर खड़े हों। कोहनी 90 डिग्री पर रखकर अपनी हथेली को दरवाजे के फ्रेम में दबाएं, जैसे कि उसे पेट की ओर ला रहे हों।",
        "gu": "દરવાજાની વચ્ચે ઉભા રહો. કોણી 90 ડિગ્રી પર રાખીને તમારી હથેળીને દરવાજાની ફ્રેમ પર દબાવો, જાણે કે તેને પેટ તરફ લાવી રહ્યા હોય."
      },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Strengthens the Subscapularis, the largest rotator cuff muscle.",
      "reps": "10",
      "sets": "2",
      "holdTime": "5-10 seconds",
      "caution": "Keep your wrist straight; do not bend it to apply pressureconst ."
    },
    {
      "id": "shoulder_007",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "QN1oZVMMRjE",
      "titles": {
        "en": "Scapular Setting (Squeezes)",
        "hi": "स्कैपुलर सेटिंग (स्क्वीज़)",
        "gu": "સ્કેપુલર સેટિંગ (સ્ક્વીઝ)"
      },
      "descriptions": {
        "en": "Squeeze your shoulder blades together and down. Imagine trying to hold a pencil between your blades.",
        "hi": "अपने कंधे के ब्लेड को एक साथ और नीचे सिकोड़ें। कल्पना करें कि आप अपने ब्लेड के बीच एक पेंसिल पकड़ने की कोशिश कर रहे हैं।",
        "gu": "તમારા ખભાના હાડકાંને એકસાથે અને નીચેની તરફ સ્ક્વીઝ કરો. કલ્પના કરો કે તમે બે હાડકાં વચ્ચે પેન્સિલ પકડવાનો પ્રયાસ કરી રહ્યા છો."
      },
      "targetSymptoms": ["Fatigue", "Weakness", "Dull Ache"],
      "clinicalBenefit": "Provides a stable base for the shoulder; prevents impingement.",
      "reps": "15",
      "sets": "3",
      "holdTime": "5 sconst econds",
      "caution": "Do not shrug your shoulders up toward your ears."
    },
    {
      "id": "shoulder_008",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "vK3pu3n1JLk",
      "titles": {
        "en": "Towel Slides (Table Slides)",
        "hi": "तौलिया स्लाइड्स (टेबल स्लाइड्स)",
        "gu": "ટુવાલ સ્લાઇડ્સ (ટેબલ સ્લાઇડ્સ)"
      },
      "descriptions": {
        "en": "Sit at a table with a towel under your hand. Slide the towel forward as far as possible, then slide it back.",
        "hi": "हाथ के नीचे तौलिया रखकर मेज पर बैठें। तौलिये को जितना हो सके आगे स्लाइड करें, फिर वापस स्लाइड करें।",
        "gu": "હાથની નીચે ટુવાલ રાખીને ટેબલ પર બેસો. ટુવાલને બને તેટલો આગળ સ્લાઇડ કરો, પછી પાછો ખેંચો."
      },
      "targetSymptoms": ["Stiffness", "Limited Motion"],
      "clinicalBenefit": "Assisted active-range-of-motion (AAROM) for shoulder flexion.",
      "reps": "15",
       "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Ensure the movement is smooth and controlled."
    },
    {
      "id": "shoulder_009",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "swvXpKN832E",
      "titles": {
        "en": "Cross-Body Stretch",
        "hi": "क्रॉस-बॉडी स्ट्रेच",
        "gu": "ક્રોસ-બોડી સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Pull your affected arm across your chest using your other arm. Hold the stretch below the elbow.",
        "hi": "अपने दूसरे हाथ का उपयोग करके अपने प्रभावित हाथ को अपनी छाती के आर-पार खींचें। कोहनी के नीचे से पकड़ें।",
        "gu": "તમારા બીજા હાથનો ઉપયોગ કરીને અસરગ્રસ્ત હાથને તમારી છાતીની આરપાર ખેંચો. કોણીની નીચેથી પકડી રાખો."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache"],
      "clinicalBenefit": "Stretches the posterior deltoid and the back of the shoulder capsule.",
      "reps": "3",
       "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Do not pull on the elbow joint itself; pull on the upper arm."
    },
    {
      "id": "shoulder_010",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "6buT-g-zEZg",
      "titles": {
        "en": "Shoulder Shrugs (Controlled)",
        "hi": "शोल्डर श्रग्स (नियंत्रित)",
        "gu": "શોલ્ડર શ્રગ્સ (નિયંત્રિત)"
      },
      "descriptions": {
        "en": "Lift your shoulders toward your ears, hold briefly, and then slowly lower them down as far as they go.",
        "hi": "अपने कंधों को अपने कानों की ओर उठाएं, थोड़ी देर रुकें, और फिर धीरे-धीरे उन्हें जितना हो सके नीचे ले जाएं।",
        "gu": "તમારા ખભાને કાન તરફ ઊંચકો, થોડીવાર પકડી રાખો અને પછી ધીમે ધીમે તેમને બને તેટલા નીચે ઉતારો."
      },
      "targetSymptoms": ["Fatigue", "Weakness"],
      "clinicalBenefit": "Improves circulation and releases tension in the Upper Trapezius.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Focus on the 'lowering' phase; it should be slow."
    } ,
    {
      "id": "chest_001",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "CEQMx4zFwYs",
      "titles": {
        "en": "Doorway Pectoral Stretch",
        "hi": "दरवाजे पर पेक्टोरल स्ट्रेच",
        "gu": "દરવાજા પર પેક્ટોરલ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place your forearms on the doorframe with elbows at shoulder height. Gently step forward with one foot until you feel a stretch across your chest.",
        "hi": "अपनी अग्रबाहुओं को दरवाजे के फ्रेम पर रखें और कोहनियों को कंधे की ऊंचाई पर रखें। धीरे-धीरे एक पैर आगे बढ़ाएं जब तक कि छाती में खिंचाव महसूस न हो।",
        "gu": "તમારા હાથના આગળના ભાગને દરવાજાની ફ્રેમ પર રાખો અને કોણીઓને ખભાની ઊંચાઈએ રાખો. છાતીમાં ખેંચાણ ન અનુભવાય ત્યાં સુધી ધીમેથી એક પગ આગળ વધારો."
      },
      "targetSymptoms": ["Tightness", "Rounded Shoulders", "Posture Issues"],
      "clinicalBenefit": "Lengthens the Pectoralis Major, reducing the forward pull on the shoulder girdle.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
       "caution": "Do not bounce; maintain a steady, gentle lean."
    },
    {
      "id": "chest_002",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "4ft6lJOZUNA",
      "titles": {
        "en": "Wall Corner Stretch",
        "hi": "दीवार के कोने पर स्ट्रेच",
        "gu": "દીવાલના ખૂણા પર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Stand facing a corner. Place one hand on each wall at shoulder height. Lean into the corner until a stretch is felt across the chest.",
        "hi": "कोने की ओर मुंह करके खड़े हो जाएं। प्रत्येक दीवार पर कंधे की ऊंचाई पर एक हाथ रखें। कोने की ओर झुकें जब तक कि छाती पर खिंचाव महसूस न हो।",
        "gu": "ખૂણા તરફ મોઢું રાખીને ઉભા રહો. દરેક દીવાલ પર ખભાની ઊંચાઈએ એક હાથ રાખો. છાતીમાં ખેંચાણ અનુભવાય ત્યાં સુધી ખૂણા તરફ નમો."
      },
      "targetSymptoms": ["Tightness", "Limited Motion", "Dull Ache"],
      "clinicalBenefit": "Allows for a deeper, bilateral stretch of the chest muscles compared to a flat wall.",
      "reps": "3",
      "sets": "1",
      "holdTime": "const 30 seconds",
      "caution": "Keep your core engaged to avoid arching your lower back."
    },
    {
      "id": "chest_003",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "7CQc5JpyZso",
      "titles": {
        "en": "Thoracic Extension over Foam Roller",
        "hi": "फोम रोलर पर थोरैसिक एक्सटेंशन",
        "gu": "ફોર્મ રોલર પર થોરેસિક એક્સ્ટેંશન"
      },
      "descriptions": {
        "en": "Lie on your back with a foam roller placed horizontally under your mid-back. Support your head and gently lean back.",
        "hi": "अपनी पीठ के बल लेट जाएं और अपनी मध्य-पीठ के नीचे क्षैतिज रूप से एक फोम रोलर रखें। अपने सिर को सहारा दें और धीरे से पीछे झुकें।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ અને તમારી પીઠના મધ્ય ભાગની નીચે આડો ફોર્મ રોલર રાખો. તમારા માથાને ટેકો આપો અને ધીમેથી પાછળ નમો."
      },
      "targetSymptoms": ["Stiffness", "Posture Issues", "Fatigue"],
      "clinicalBenefit": "Mobilizes the thoracic spine and opens the anterior chest wall simultaneously.",
      "reps": "5",
      "sets": "2",
      "hconst oldTime": "10 seconds",
      "caution": "Support your neck; do not let your head hang unsupported."
    },
    {
      "id": "chest_004",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "vMjTJf4-xz0",
      "titles": {
        "en": "Deep Diaphragmatic Breathing",
        "hi": "गहरी डायफ्रामिक श्वास",
        "gu": "ઊંડા શ્વાસોશ્વાસ (ડાયાફ્રેમેટિક બ્રીધિંગ)"
      },
      "descriptions": {
        "en": "Place one hand on your chest and the other on your belly. Inhale deeply through your nose, ensuring only the belly hand rises.",
        "hi": "एक हाथ अपनी छाती पर और दूसरा अपने पेट पर रखें। अपनी नाक से गहरी सांस लें, सुनिश्चित करें कि केवल पेट वाला हाथ ऊपर उठे।",
        "gu": "એક હાથ તમારી છાતી પર અને બીજો તમારા પેટ પર રાખો. નાક દ્વારા ઊંડો શ્વાસ લો, ખાતરી કરો કે માત્ર પેટ પરનો હાથ જ ઉપર આવે."
      },
      "targetSymptoms": ["Tightness", "Rib Pain", "Shortness of Breath"],
      "clinicalBenefit": "Improves rib cage expansion and reduces reliance on accessory neck muscles for breathing.",
      "reps": "10" ,
      "sets": "2",
      "holdTime": "3 second inhale/exhale",
      "caution": "Avoid shrugging your shoulders while inhaling."
    },
    {
      "id": "chest_005",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "o5ug9gRyD_M",
      "titles": {
        "en": "Prone T-Stretch",
        "hi": "प्रोन टी-स्ट्रेच (जमीन पर छाती का खिंचाव)",
        "gu": "પ્રોન ટી-સ્ટ્રેચ (જમીન પર છાતીનું ખેંચાણ)"
      },
      "descriptions": {
        "en": "Lie face down with arms out like a 'T'. Roll your body toward one side, until you feel a stretch in the chest.",
        "hi": "हाथों को 'T' की तरह बाहर फैलाकर पेट के बल लेट जाएं। अपने शरीर को एक तरफ रोल करें, जब तक कि आपको छाती में खिंचाव महसूस न हो।",
        "gu": "હાથને 'T' આકારમાં ફેલાવીને પેટ પર સૂઈ જાઓ. છાતીમાં ખેંચાણ અનુભવાય ત્યાં સુધી તમારા શરીરને એક બાજુ ફેરવો (રોલ કરો)."
      },
      "targetSymptoms": ["Sharp Pain", "Tightness", "Limited Motion"],
      "clinicalBenefit": "Provides a targeted stretch for the Pectoralis Minor and anterior shoulder capsuconst le.",
      "reps": "2 per side",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Move slowly; stop if you feel any tingling in the arm."
    },
    {
      "id": "chest_006",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "GV3o1iG9UjM",
      "titles": {
        "en": "Scapular Retraction (No-Money Exercise)",
        "hi": "स्कैपुलर रिट्रैक्शन (नो-मनी एक्सरसाइज)",
        "gu": "સ્કેપુલર રિટ્રેક્શન (નો-મની એક્સરસાઇઝ)"
      },
      "descriptions": {
        "en": "Keep elbows tucked to your sides at 90 degrees. Rotate your palms outward while squeezing your shoulder blades together.",
        "hi": "कोहनियों को 90 डिग्री पर अपने बगल में सटाकर रखें। अपने कंधे के ब्लेड को एक साथ सिकोड़ते हुए अपनी हथेलियों को बाहर की ओर घुमाएं।",
        "gu": "કોણીને 90 ડિગ્રીએ તમારી બાજુમાં દબાવી રાખો. તમારા ખભાના હાડકાંને નજીક લાવીને સ્ક્વીઝ કરતી વખતે હથેળીઓને બહારની તરફ ફેરવો."
      },
      "targetSymptoms": ["Weakness", "Fatigue", "Rounded Shoulders"],
      "clinicalBenefit": "Strengthens tconst he muscles that pull the chest open naturally.",
      "reps": "15",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Keep your elbows pinned to your ribs throughout."
    },
    {
      "id": "chest_007",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "-U2NxmqOSGU",
      "titles": {
        "en": "Bruggers Postural Relief",
        "hi": "ब्रुगर्स पोस्टुरल रिलीफ",
        "gu": "બ્રગર્સ પોશ્ચરલ રિલીફ"
      },
      "descriptions": {
        "en": "Sit at the edge of a chair. Open your arms wide, palms up, and tuck your chin while squeezing shoulder blades down.",
        "hi": "कुर्सी के किनारे पर बैठें। अपनी भुजाओं को चौड़ा खोलें, हथेलियाँ ऊपर की ओर, और कंधों के ब्लेड को नीचे सिकोड़ते हुए अपनी ठुड्डी को अंदर की ओर दबाएं।",
        "gu": "ખુરશીની કિનારી પર બેસો. તમારા હાથને પહોળા ફેલાવો, હથેળીઓ ઉપર રાખો, અને ખભાના હાડકાંને નીચે સ્ક્વીઝ કરતી વખતે રામરામને અંદર દબાવો."
      },
      "targetSymptoms": ["Posture Issues", "Dull Ache", "Stiffness"],
      "cliniconst calBenefit": "A clinical 'reset' for the chest and upper back often used for desk workers.",
      "reps": "5",
      "sets": "1",
      "holdTime": "10 seconds",
      "caution": "Think about 'opening' your heart toward the ceiling."
    },
    {
      "id": "chest_008",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "7iscKvjmy_g",
      "titles": {
        "en": "Floor Chest Openers (Book Openings)",
        "hi": "फ्लोर चेस्ट ओपनर्स (बुक ओपनिंग्स)",
        "gu": "ફ્લોર ચેસ્ટ ઓપનર્સ (બુક ઓપનિંગ્સ)"
      },
      "descriptions": {
        "en": "Lie on your side with knees bent. Reach your top arm over to the other side, following it with your eyes, to open the chest.",
        "hi": "घुटनों को मोड़कर अपनी करवट के बल लेट जाएं। अपनी आंखों से हाथ का पीछा करते हुए, ऊपरी हाथ को दूसरी तरफ ले जाएं ताकि छाती खुल सके।",
        "gu": "ઘૂંટણ વાળીને પડખે સૂઈ જાઓ. છાતી ખોલવા માટે તમારી આંખોથી હાથને અનુસરતા, ઉપરના હાથને બીજી બાજુ લઈ જાઓ."
       },
      "targetSymptoms": ["Limited Motion", "Stiffness", "Rib Pain"],
      "clinicalBenefit": "Combines thoracic rotation with a dynamic chest stretch.",
      "reps": "10 per side",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Keep your knees together and on the floor."
    },
    {
      "id": "chest_009",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "WIdjSjzNS2A",
      "titles": {
        "en": "Serratus Anterior Wall Slides",
        "hi": "सेराटस एंटीरियर वॉल स्लाइड्स",
        "gu": "સેરેટસ એન્ટીરિયર વોલ સ્લાઇડ્સ"
      },
      "descriptions": {
        "en": "Place forearms on the wall. Slide them upward while pushing your body slightly away from the wall.",
        "hi": "अग्रबाहुओं को दीवार पर रखें। अपने शरीर को दीवार से थोड़ा दूर धकेलते हुए उन्हें ऊपर की ओर स्लाइड करें।",
        "gu": "આગળના હાથને (ફોરઆર્મ્સ) દીવાલ પર રાખો. તમારા શરીરને દીવાલથી સહેજ દૂર ધકેલતી વખતે તેમને ઉપરની તરફ સ્લાઇડ કરો."
       },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Strengthens the serratus anterior, which helps stabilize the ribs and chest wall.",
      "reps": "10",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Ensure your shoulder blades move around the rib cage, not just up."
    },
    {
      "id": "chest_010",
      "targetBodyPart": "Chest",
      "category": "Pectoral Opening & Rib Mobility",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "uglvIE8_0r0",
      "titles": {
        "en": "Supine Chest Expansion with Pillow",
        "hi": "तकिये के साथ सुपाइन चेस्ट एक्सपेंशन",
        "gu": "તકિયા સાથે સુપાઇન ચેસ્ટ એક્સપાન્શન"
      },
      "descriptions": {
        "en": "Lie on your back with a pillow placed vertically along your spine. Let your arms fall out to the sides.",
        "hi": "अपनी रीढ़ के साथ लंबवत रखे हुए तकिये के साथ अपनी पीठ के बल लेट जाएं। अपनी भुजाओं को किनारों पर गिरने दें।",
        "gu": "તમારી કરોડરજ્જુની લંબાઈમાં તકિયો રાખીને પીઠ પર સૂઈ જાઓ. તમારા હાથને બાજુઓ પર ઢીલા છોડી દો."
      },
      "targetSymptoms": ["General Tightness", "Fatigue"],
      "clinicalBenefit": "A passive stretch that uses gravity to reverse forward-slumped posture.",
      "reps": "1",
      "sets": "1",
      "holdTime": "2-3 minutes",
      "caution": "If you feel discomfort in the lower back, bend your knees."
    },

    {
      "id": "lback_001",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "44D6Xc2Fkek",
      "titles": {
        "en": "Pelvic Tilts",
        "hi": "पेल्विक टिल्ट्स",
        "gu": "પેલ્વિક ટિલ્ટ્સ"
      },
      "descriptions": {
        "en": "Lie on your back with knees bent. Tighten your abdominal muscles and flatten your back against the floor by tilting your pelvis upward.",
        "hi": "घुटनों को मोड़कर अपनी पीठ के बल लेट जाएं। अपने पेट की मांसपेशियों को कसें और अपनी पीठ को फर्श से सटाएं।",
        "gu": "ઘૂંટણ વાળીને તમારી પીઠ પર સૂઈ જાઓ. તમારા પેટના સ્નાયુઓને સજ્જડ કરો અને તમારી પીઠને જમીન સાથે સપાટ કરો."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache", "Posture Issues"],
      "clinicalBenefit": "Engages the Transversus Abdominis and improves segmental control of the lumbar vertebrae.",
      "reps": "15",
      "sets": "2",
      "holdTime": "3 seconds",
      "caution": "Do not hold your breath; focus on a smooth, rhythmic tilting motion."
    },
    {
      "id": "lback_002",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "yVy4L0CGbyQ",
      "titles": {
        "en": "Knee-to-Chest Stretch",
        "hi": "घुटने से छाती तक खिंचाव",
        "gu": "ઘૂંટણથી છાતી સુધીનું ખેંચાણ"
      },
      "descriptions": {
        "en": "Lie on your back. Pull one knee toward your chest with both hands. Hold, then repeat with the other leg.",
        "hi": "अपनी पीठ के बल लेट जाएं। दोनों हाथों से एक घुटने को अपनी छाती की ओर खींचें। रुकें, फिर दूसरे पैर से दोहराएं।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ. બંને હાથ વડે એક ઘૂંટણને તમારી છાતી તરફ ખેંચો. પકડી રાખો, પછી બીજા પગ સાથે પુનરાવર્તન કરો."
      },
      "targetSymptoms": ["Stiffness", "Sharp Pain", "Limited Motion"],
      "clinicalBenefit": "Stretches the paraspinal muscles and opens the intervertebral foramen to relieve pressure.",
      "reps": "3 per side",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "If you have a known disc bulge, do not pull too aggressively; stay in a pain-free range."
    },
    {
      "id": "lback_003",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "cqe97lhKVP4",
      "titles": {
        "en": "Bird-Dog (Quadruped Stability)",
        "hi": "बर्ड-डॉग (स्थिरता अभ्यास)",
        "gu": "બર્ડ-ડોગ (સ્થિરતા અભ્યાસ)"
      },
      "descriptions": {
        "en": "On all fours, simultaneously extend your right arm forward and left leg backward. Keep your back flat like a table.",
        "hi": "दोनों हाथों और पैरों के बल आएं, साथ ही अपने दाहिने हाथ को आगे और बाएं पैर को पीछे की ओर फैलाएं। अपनी पीठ को टेबल की तरह सपाट रखें।",
        "gu": "બંને હાથ અને પગ પર રહો, એકસાથે તમારા જમણા હાથને આગળ અને ડાબા પગને પાછળ લંબાવો. તમારી પીઠને ટેબલની જેમ સપાટ રાખો."
      },
      "targetSymptoms": ["Weakness", "Instability", "Fatigue"],
      "clinicalBenefit": "Trains the Multifidus muscle, which is the primary stabilizer of the lower spine.",
      "reps": "10 per side",
      "sets": "2",
      "holdTime": "5 seconds",
      "caution": "Do not let your back arch; keep your hips square to the floor."
    },
    {
      "id": "lback_004",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "UqSP7ZrHxRE",
      "titles": {
        "en": "McKenzie Extension (Prone Press-ups)",
        "hi": "मैकेंजी एक्सटेंशन",
        "gu": "મેકેન્ઝી એક્સ્ટેંશન"
      },
      "descriptions": {
        "en": "Lie face down. Use your arms to push your upper body up while keeping your hips on the floor.",
        "hi": "पेट के बल लेट जाएं। अपने कूल्हों को फर्श पर रखते हुए अपने ऊपरी शरीर को ऊपर धकेलने के लिए अपनी भुजाओं का उपयोग करें।",
        "gu": "પેટ પર સૂઈ જાઓ. તમારા નિતંબને જમીન પર રાખીને તમારા શરીરના ઉપરના ભાગને ઉપર ધકેલવા માટે તમારા હાથનો ઉપયોગ કરો."
      },
      "targetSymptoms": ["Sciatica", "Numbness", "Tingling"],
      "clinicalBenefit": "Promotes 'centralization' of disc-related pain, moving symptoms from the leg back to the spine.",
      "reps": "10",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Stop immediately if pain moves further down the leg (peripheralization)."
    },
    {
      "id": "lback_005",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "DdUKPepLsTw",
      "titles": {
        "en": "Dead Bug",
        "hi": "डेड बग",
        "gu": "ડેડ બગ"
      },
      "descriptions": {
        "en": "Lie on your back with arms up and knees at 90 degrees. Slowly lower opposite arm and leg toward the floor without arching your back.",
        "hi": "अपनी पीठ के बल लेटें, हाथ ऊपर और घुटने 90 डिग्री पर रखें। अपनी पीठ को मोड़े बिना विपरीत हाथ और पैर को धीरे-धीरे फर्श की ओर नीचे करें।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ, હાથ ઉપર અને ઘૂંટણ 90 ડિગ્રી પર રાખો. તમારી પીઠ વાળ્યા વિના વિરુદ્ધ હાથ અને પગને ધીમે ધીમે જમીન તરફ નીચે કરો."
      },
      "targetSymptoms": ["Weakness", "Posture Issues", "Dull Ache"],
      "clinicalBenefit": "Strengthens the deep core while maintaining a neutral spine.",
      "reps": "10 per side",
      "sets": "3",
      "holdTime": "Control-focused",
      "caution": "If your lower back lifts off the floor, do not lower your leg as far."
    },
    {
      "id": "lback_006",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "tqp5XQPpTxY",
      "titles": {
        "en": "Glute Bridges",
        "hi": "ग्लूट ब्रिजेस",
        "gu": "ગ્લુટ બ્રિજિસ"
      },
      "descriptions": {
        "en": "Lie on your back with knees bent. Lift your hips toward the ceiling by squeezing your glutes.",
        "hi": "घुटनों को मोड़कर अपनी पीठ के बल लेट जाएं। अपने कूल्हों को छत की ओर उठाएं और कूल्हों की मांसपेशियों को सिकोड़ें।",
        "gu": "ઘૂંટણ વાળીને તમારી પીઠ પર સૂઈ જાઓ. તમારા નિતંબને ઉપર તરફ ઉઠાવો અને સ્નાયુઓને સ્ક્વીઝ કરો."
      },
      "targetSymptoms": ["Weakness", "Fatigue", "Posture Issues"],
      "clinicalBenefit": "Strengthens the posterior chain to take the load off the lower back muscles.",
      "reps": "15",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Do not over-arch the back at the top; keep a straight line from knees to shoulders."
    },
    {
      "id": "lback_007",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "g0nuyTHMrI",
      "titles": {
        "en": "Piriformis Stretch (Figure 4)",
        "hi": "पिरिफोर्मिस स्ट्रेच",
        "gu": "પિરિફોર્મિસ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Lie on your back. Cross your right ankle over your left knee. Pull your left thigh toward your chest.",
        "hi": "अपनी पीठ के बल लेटें। अपने दाहिने टखने को अपने बाएं घुटने के ऊपर रखें। अपनी बाईं जांघ को अपनी छाती की ओर खींचें।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ. તમારા જમણા પગની ઘૂંટીને તમારા ડાબા ઘૂંટણ પર રાખો. તમારી ડાબી સાથળને તમારી છાતી તરફ ખેંચો."
      },
      "targetSymptoms": ["Sciatica", "Sharp Pain", "Burning"],
      "clinicalBenefit": "Releases the piriformis muscle, which can often compress the sciatic nerve.",
      "reps": "3 per side",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Keep your foot flexed to protect the knee joint."
    },
    {
      "id": "lback_008",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Intermediate",
      "maxPainScore": 7,
      "youtubeId": "XP1yzpFR6ho",
      "titles": {
        "en": "Sciatic Nerve Glide (Flossing)",
        "hi": "सायटिक नर्व ग्लाइड",
        "gu": "સાયટિક નર્વ ગ્લાઇડ"
      },
      "descriptions": {
        "en": "Sit on a chair, slouch slightly. Straighten one knee while looking up at the ceiling, then bend the knee while looking down.",
        "hi": "कुर्सी पर बैठें, थोड़ा झुकें। छत की ओर देखते हुए एक घुटना सीधा करें, फिर नीचे देखते हुए घुटना मोड़ें।",
        "gu": "ખુરશી પર બેસો, સહેજ નમો. છત તરફ જોતી વખતે એક ઘૂંટણ સીધો કરો, પછી નીચે જોતી વખતે ઘૂંટણ વાળો."
      },
      "targetSymptoms": ["Numbness", "Tingling", "Tension"],
      "clinicalBenefit": "Mobilizes the nerve within its sheath without overstretching it.",
      "reps": "10",
      "sets": "1",
      "holdTime": "Flowing",
      "caution": "Do not 'stretch' the nerve; keep the movement gentle and rhythmic."
    },
    {
      "id": "lback_009",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "oa6BNZVukDc",
      "titles": {
        "en": "Transverse Abdominis (TA) Activation",
        "hi": "पेट की मांसपेशियों का संकुचन",
        "gu": "પેટના સ્નાયુઓનું સંકોચન"
      },
      "descriptions": {
        "en": "Lie on your back. Gently draw your belly button toward your spine without moving your ribs or holding your breath.",
        "hi": "अपनी पीठ के बल लेटें। अपनी पसलियों को हिलाए बिना या अपनी सांस रोके बिना अपनी नाभि को धीरे से अपनी रीढ़ की ओर खींचें।",
        "gu": "તમારી પીઠ પર સૂઈ જાઓ. તમારી પાંસળીને હલાવ્યા વિના અથવા તમારો શ્વાસ રોક્યા વિના તમારી નાભિને ધીમેથી તમારી કરોડરજ્જુ તરફ ખેંચો."
      },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Activates the body's internal 'weight belt' for spinal protection.",
      "reps": "10",
      "sets": "1",
      "holdTime": "10 seconds",
      "caution": "This is a subtle contraction, not a forceful stomach vacuum."
    },
    {
      "id": "lback_010",
      "targetBodyPart": "Lower Back",
      "category": "Lumbar Stability & Core Integration",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "KWi1YgyxDaQ",
      "titles": {
        "en": "Sphinx Pose",
        "hi": "स्फिंक्स पोज़",
        "gu": "સ્ફિન્ક્સ પોઝ"
      },
      "descriptions": {
        "en": "Lie on your stomach and prop yourself up on your forearms. Keep your shoulders away from your ears.",
        "hi": "पेट के बल लेटें और अपनी कोहनियों के बल खुद को ऊपर उठाएं। अपने कंधों को अपने कानों से दूर रखें।",
        "gu": "પેટ પર સૂઈ જાઓ અને તમારી કોણીના ટેકે તમારી જાતને ઉપર ઉઠાવો. તમારા ખભાને તમારા કાનથી દૂર રાખો."
      },
      "targetSymptoms": ["Stiffness", "Limited Motion", "Spondylitis"],
      "clinicalBenefit": "Provides a sustained, gentle extension for the lumbar spine.",
      "reps": "1",
      "sets": "1",
      "holdTime": "60 seconds",
      "caution": "If you feel a sharp pinch in the lower back, lower your chest slightly."
    },



    {
      "id": "uback_001",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "Y-s5X4yKPCs",
      "titles": {
        "en": "Cat-Cow Stretch",
        "hi": "मार्जरी आसन (कैट-काउ स्ट्रेच)",
        "gu": "માર્જરી આસન (કેટ-કાઉ સ્ટ્રેચ)"
      },
      "descriptions": {
        "en": "On all fours, inhale as you arch your back and look up (Cow). Exhale as you round your spine and tuck your chin (Cat).",
        "hi": "दोनों हाथों और घुटनों के बल आएं। सांस लेते हुए पीठ को नीचे की ओर मोड़ें और ऊपर देखें। सांस छोड़ते हुए रीढ़ को ऊपर की ओर गोल करें।",
        "gu": "બંને હાથ અને ઘૂંટણ પર બેસો. શ્વાસ લેતી વખતે પીઠને નીચેની તરફ વાળો અને ઉપર જુઓ. શ્વાસ છોડતી વખતે કરોડરજ્જુને ઉપરની તરફ ગોળ કરો."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache", "Limited Motion"],
      "clinicalBenefit": "Improves segmental mobility of the entire thoracic and lumbar spine.",
      "reps": "10 cycles",
      "sets": "2",
      "holdTime": "3 seconds per pose",
      "caution": "Move fluidly; do not force the end range if you feel sharp pain."
    },
    {
      "id": "uback_002",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "kCoTeRB8c-g",
      "titles": {
        "en": "Thoracic Extension (Chair)",
        "hi": "थोरैसिक एक्सटेंशन (कुर्सी पर)",
        "gu": "થોરેસિક એક્સ્ટેંશન (ખુરશી પર)"
      },
      "descriptions": {
        "en": "Sit in a chair with a mid-height back. Lace fingers behind your neck and gently lean backward over the top of the chair.",
        "hi": "मध्यम ऊंचाई वाली कुर्सी पर बैठें। अपनी उंगलियों को गर्दन के पीछे फंसाएं और धीरे से कुर्सी के ऊपरी हिस्से के ऊपर पीछे की ओर झुकें।",
        "gu": "મધ્યમ ઊંચાઈની ખુરશી પર બેસો. તમારી આંગળીઓને ગરદનની પાછળ ભીડાવો અને ધીમેથી ખુરશીના ઉપરના ભાગ પર પાછળની તરફ નમો."
      },
      "targetSymptoms": ["Rounded Shoulders", "Posture Issues", "Stiffness"],
      "clinicalBenefit": "Counteracts the 'hunched' posture from desk work by extending the thoracic vertebrae.",
      "reps": "5",
      "sets": "3",
      "holdTime": "5-10 seconds",
      "caution": "Support your neck with your hands; do not let your head drop back loosely."
    },
    {
      "id": "uback_003",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "Inlria8Vi8k",
      "titles": {
        "en": "Thread the Needle",
        "hi": "थ्रेड द नीडल",
        "gu": "થ્રેડ ધ નીડલ"
      },
      "descriptions": {
        "en": "On all fours, slide one arm under the opposite armpit, reaching as far as possible until your shoulder touches the floor.",
        "hi": "दोनों हाथों और घुटनों के बल आएं। एक हाथ को दूसरी बगल के नीचे से सरકાएं, जब સુધી કે તમારો ખભો જમીનને ન અડે.",
        "gu": "બંને હાથ અને ઘૂંટણ પર બેસો. એક હાથને બીજી બગલની નીચેથી સરકાવો, જ્યાં સુધી તમારો ખભો જમીનને ન અડે."
      },
      "targetSymptoms": ["Limited Motion", "Tingling", "Stiffness"],
      "clinicalBenefit": "Provides essential thoracic rotation, which is often lost in sedentary lifestyles.",
      "reps": "5 per side",
      "sets": "2",
      "holdTime": "15 seconds",
      "caution": "Keep your hips square; the twist should come from the upper back, not the waist."
    },
    {
      "id": "uback_004",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "ouRhQE2iOI8",
      "titles": {
        "en": "W-Y Squeezes",
        "hi": "W-Y स्क्वीज़",
        "gu": "W-Y સ્ક્વીઝ"
      },
      "descriptions": {
        "en": "Start with arms in a 'Y' position above your head. Pull elbows down to your ribs to form a 'W', squeezing your shoulder blades.",
        "hi": "हाथों को सिर के ऊपर 'Y' स्थिति में रखें। कोहनियों को नीचे पसलियों की ओर खींचकर 'W' बनाएं और कंधों के ब्लेड को सिकोड़ें।",
        "gu": "હાથને માથાની ઉપર 'Y' આકારમાં રાખો. કોણીઓને નીચે પાંસળીઓ તરફ ખેંચીને 'W' આકાર બનાવો અને ખભાના હાડકાંને સ્ક્વીઝ કરો."
      },
      "targetSymptoms": ["Weakness", "Fatigue", "Dull Ache"],
      "clinicalBenefit": "Activates the lower trapezius and rhomboids to stabilize the scapula.",
      "reps": "12",
      "sets": "3",
      "holdTime": "3 seconds",
      "caution": "Keep your ribcage tucked; do not flare your chest out excessively."
    },
    {
      "id": "uback_005",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "B9uY01NoqBg",
      "titles": {
        "en": "Doorway Thoracic Stretch",
        "hi": "डोरवे थोरैसिक स्ट्रेच",
        "gu": "ડોરવે થોરેસિક સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Stand in a doorway with arms high on the frame. Step forward with one foot until you feel a stretch across your chest and upper back.",
        "hi": "दरवाजे के फ्रेम पर हाथ ऊंचे रखकर खड़े हों। एक पैर आगे बढ़ाएं जब तक कि आपको छाती और ऊपरी पीठ में खिंचाव महसूस न हो।",
        "gu": "દરવાજાની ફ્રેમ પર હાથ ઊંચા રાખીને ઉભા રહો. એક પગ આગળ વધારો જ્યાં સુધી તમને છાતી અને ઉપરની પીઠમાં ખેંચાણ અનુભવાય."
      },
      "targetSymptoms": ["Stiffness", "Burning", "Posture Issues"],
      "clinicalBenefit": "Opens the anterior chest wall to allow the upper back muscles to relax.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Ensure your elbows are slightly above shoulder height for best results."
    },
    {
      "id": "uback_006",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "cvx06snMQ3A",
      "titles": {
        "en": "Wall Angels",
        "hi": "वॉल एंजल्स",
        "gu": "વોલ એન્જલ્સ"
      },
      "descriptions": {
        "en": "Stand with back, head, and arms flat against a wall. Slowly slide your arms up and down like a snow angel.",
        "hi": "दीवार से सटकर खड़े हों। धीरे-धीरे अपने हाथों को दीवार के सहारे ऊपर और नीचे स्लाइड करें जैसे स्नो एंजेल बना रहे हों।",
        "gu": "દીવાલને અડીને ઉભા રહો. ધીમે ધીમે તમારા હાથને દીવાલના સહારે ઉપર અને નીચે સ્લાઇડ કરો જેમ સ્નો એન્જલ બનાવી રહ્યા હોય."
      },
      "targetSymptoms": ["Posture Issues", "Weakness", "Limited Motion"],
      "clinicalBenefit": "A high-level postural reset that integrates thoracic extension and scapular control.",
      "reps": "10",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Try to keep your lower back pressed against the wall throughout the movement."
    },
    {
      "id": "uback_007",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "W9Xem1lHspU",
      "titles": {
        "en": "Rhomboid Stretch",
        "hi": "रॉम्बॉइड स्ट्रेच",
        "gu": "રોમ્બોઇડ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Reach arms forward and interlock fingers. Push your hands away while rounding your upper back and tucking your chin.",
        "hi": "हाथों को आगे बढ़ाएं और उंगलियों को आपस में फंसाएं। अपनी ऊपरी पीठ को गोल करते हुए और ठुड्डी को अंदर दबाते हुए हाथों को आगे की ओर धकेलें।",
        "gu": "હાથને આગળ લંબાવો અને આંગળીઓને અંદરોઅંદર ભીડાવો. તમારી ઉપરની પીઠને ગોળ કરતી વખતે અને રામરામને અંદર દબાવતી વખતે હાથને આગળની તરફ ધકેલો."
      },
      "targetSymptoms": ["Sharp Pain", "Dull Ache", "Knots"],
      "clinicalBenefit": "Directly stretches the muscles between the shoulder blades.",
      "reps": "3",
      "sets": "2",
      "holdTime": "20 seconds",
      "caution": "Breathe deeply into the space between your shoulder blades."
    },
    {
      "id": "uback_008",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "kH12QrSGedM",
      "titles": {
        "en": "Child’s Pose (Side Reaching)",
        "hi": "बालासन (साइड रीचिंग)",
        "gu": "બાલાસન (સાઇડ રીચિંગ)"
      },
      "descriptions": {
        "en": "From a kneeling position, sit back on your heels and reach arms forward. Walk both hands to the right, then to the left.",
        "hi": "घुटने टेककर एड़ी पर बैठें और हाथों को आगे बढ़ाएं। दोनों हाथों को पहले दाईं ओर और फिर बाईं ओर ले जाएं।",
        "gu": "ઘૂંટણ ટેકવીને એડી પર બેસો અને હાથને આગળ લંબાવો. બંને હાથને પહેલા જમણી તરફ અને પછી ડાબી તરફ લઈ જાઓ."
      },
      "targetSymptoms": ["Stiffness", "Fatigue"],
      "clinicalBenefit": "Stretches the Latissimus Dorsi and opens the thoracic cage.",
      "reps": "2 per side",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "If you have knee pain, place a pillow between your thighs and calves."
    },
    {
      "id": "uback_009",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 5,
      "youtubeId": "FTpVhBkyIzk",
      "titles": {
        "en": "Scapular Push-ups",
        "hi": "स्कैपुलर पुश-अप्स",
        "gu": "સ્કેપુલર પુશ-અપ્સ"
      },
      "descriptions": {
        "en": "In a plank or on knees, keep arms straight. Sink your chest toward the floor by bringing blades together, then push up to separate them.",
        "hi": "प्लैंक या घुटनों के बल रहें, हाथ सीधे रखें। अपने कंधों के ब्लेड को पास लाकर छाती को नीचे करें, फिर उन्हें दूर करने के लिए ऊपर धकेलें।",
        "gu": "પ્લેન્ક અથવા ઘૂંટણ પર રહો, હાથ સીધા રાખો. તમારા ખભાના હાડકાંને નજીક લાવીને છાતીને નીચે કરો, પછી તેમને દૂર કરવા માટે ઉપર ધકેલો."
      },
      "targetSymptoms": ["Weakness", "Clicking/Popping"],
      "clinicalBenefit": "Strengthens the Serratus Anterior, preventing 'winging' of the shoulder blades.",
      "reps": "10",
      "sets": "3",
      "holdTime": "2 seconds",
      "caution": "Do not bend your elbows; the movement happens only at the shoulder blades."
    },
    {
      "id": "uback_010",
      "targetBodyPart": "Upper Back",
      "category": "Thoracic Mobility & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 4,
      "youtubeId": "QdGTI4Lshg4",
      "titles": {
        "en": "Prone T-Lift",
        "hi": "प्रोन टी-लिफ्ट",
        "gu": "પ્રોન ટી-લિફ્ટ"
      },
      "descriptions": {
        "en": "Lie face down with arms out to the sides (forming a T). Lift your arms toward the ceiling, squeezing your blades together.",
        "hi": "पेट के बल लेट जाएं और हाथों को साइड में फैलाएं (T आकार)। अपने हाथों को ऊपर उठाएं और कंधों के ब्लेड को एक साथ सिकोड़ें।",
        "gu": "પેટ પર સૂઈ જાઓ અને હાથને બાજુ પર ફેલાવો (T આકાર). તમારા હાથને ઉપર ઉઠાવો અને ખભાના હાડકાંને એકસાથે સ્ક્વીઝ કરો."
      },
      "targetSymptoms": ["Weakness", "Posture Issues"],
      "clinicalBenefit": "Strengthens the posterior chain and mid-back to prevent slouching.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Keep your forehead on the floor to avoid straining your neck."
    },




    {
      "id": "shoulder_001",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "QF_ubbr_RUE",
      "titles": {
        "en": "Pendulum Swings (Codman's)",
        "hi": "पेंडुलम स्विंग्स",
        "gu": "પેન્ડુલમ સ્વિંગ્સ"
      },
      "descriptions": {
        "en": "Lean forward resting one arm on a table. Let the painful arm hang down and swing it gently in small circles, then side-to-side.",
        "hi": "एक हाथ को मेज पर रखकर आगे की ओर झुकें। दर्द वाले हाथ को नीचे लटकने दें और उसे धीरे-धीरे छोटे घेरों में, फिर अगल-बगल घुमाएं।",
        "gu": "એક હાથને ટેબલ પર ટેકવીને આગળ નમો. દુખાવાવાળા હાથને નીચે લટકવા દો અને તેને ધીમેથી નાના વર્તુળોમાં અને પછી આજુબાજુ ફેરવો."
      },
      "targetSymptoms": ["Sharp Pain", "Limited Motion", "Stiffness"],
      "clinicalBenefit": "Uses gravity to distract the humerus from the glenoid, providing pain relief without muscle strain.",
      "reps": "20 circles each way",
      "sets": "2",
      "holdTime": "N/A",
      "caution": "Do not use your arm muscles to move; let the momentum of your body do the work."
    },
    {
      "id": "shoulder_002",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "bfOEqkWTvZo",
      "titles": {
        "en": "Wall Crawls (Finger Ladder)",
        "hi": "वॉल क्रॉल्स (फिंगर लैडर)",
        "gu": "વોલ ક્રોલ્સ (ફિંગર લેડર)"
      },
      "descriptions": {
        "en": "Stand facing a wall. Use your fingers to 'walk' up the wall as high as you can without significant pain.",
        "hi": "दीवार की ओर मुंह करके खड़े हों। अपनी उंगलियों का उपयोग करके दीवार पर जितना हो सके उतना ऊपर चढ़ें बिना किसी खास दर्द के।",
        "gu": "દીવાલ તરફ મોઢું રાખીને ઉભા રહો. તમારી આંગળીઓનો ઉપયોગ કરીને દીવાલ પર બને તેટલા ઉપર ચઢો (વધારે દુખાવો ન થાય ત્યાં સુધી)."
      },
      "targetSymptoms": ["Limited Motion", "Stiffness"],
      "clinicalBenefit": "Gradually increases shoulder flexion and abduction range of motion.",
      "reps": "5-10 crawls",
      "sets": "3",
      "holdTime": "5 seconds at top",
      "caution": "Do not arch your back to get higher; keep your spine neutral."
    },
    {
      "id": "shoulder_003",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "M850sCj9LHQ",
      "titles": {
        "en": "Doorway Pectoral Stretch",
        "hi": "डोरवे पेक्टोरल स्ट्रेच",
        "gu": "ડોરવે પેક્ટોરલ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Place your forearms on the doorframe with elbows at shoulder height. Gently lean forward through the door.",
        "hi": "अपनी अग्रबाहुओं को दरवाजे के फ्रेम पर रखें और कोहनियों को कंधे की ऊंचाई पर रखें। धीरे से दरवाजे के माध्यम से आगे झुकें।",
        "gu": "તમારી આગળની ભુજાઓને દરવાજાની ફ્રેમ પર રાખો અને કોણીઓને ખભાની ઊંચાઈએ રાખો. ધીમેથી દરવાજાની વચ્ચેથી આગળ નમો."
      },
      "targetSymptoms": ["Stiffness", "Rounded Shoulders", "Dull Ache"],
      "clinicalBenefit": "Opens the chest and reduces anterior pull on the shoulder joint, improving posture.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Stop if you feel tingling or numbness in your fingers."
    },
    {
      "id": "shoulder_004",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "9BN8bRVq3Xo",
      "titles": {
        "en": "Sleeper Stretch",
        "hi": "स्लीपर स्ट्रेच",
        "gu": "સ્લીપર સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Lie on your affected side with shoulder and elbow at 90 degrees. Use your other hand to push your forearm down toward the bed.",
        "hi": "प्रभावित करवट पर लेट जाएं, कंधे और कोहनी 90 डिग्री पर रखें। दूसरे हाथ से अपनी अग्रबाहु को बिस्तर की ओर नीचे धकेलें।",
        "gu": "અસરગ્રસ્ત પડખે સૂઈ જાઓ, ખભા અને કોણી 90 ડિગ્રી પર રાખો. બીજા હાથનો ઉપયોગ કરીને તમારા હાથના નીચેના ભાગને પથારી તરફ નીચે ધકેલો."
      },
      "targetSymptoms": ["Limited Motion", "Stiffness", "Clicking/Popping"],
      "clinicalBenefit": "Targets the Posterior Capsule; essential for internal rotation deficits.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Push very gently; this is a sensitive joint capsule stretch."
    },
    {
      "id": "shoulder_005",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "K1OWFdhPbAg",
      "titles": {
        "en": "Isometric External Rotation",
        "hi": "आइसोमेट्रिक एक्सटर्नल रोटेशन",
        "gu": "આઇસોમેટ્રિક એક્સટર્નલ રોટેશન"
      },
      "descriptions": {
        "en": "Stand sideways to a wall. With elbow tucked at 90 degrees, press the back of your wrist into the wall.",
        "hi": "दीवार के बगल में खड़े हों। कोहनी को 90 डिग्री पर सटाकर रखें, अपनी कलाई के पिछले हिस्से को दीवार में दबाएं।",
        "gu": "દીવાલની બાજુમાં ઉભા રહો. કોણીને 90 ડિગ્રીએ દબાવી રાખો, તમારા કાંડાના પાછળના ભાગને દીવાલ પર દબાવો."
      },
      "targetSymptoms": ["Weakness", "Dull Ache", "Instability"],
      "clinicalBenefit": "Strengthens the Infraspinatus and Teres Minor without joint movement.",
      "reps": "10",
      "sets": "2",
      "holdTime": "5-10 seconds",
      "caution": "Keep your elbow glued to your side; do not let it flare out."
    },
    {
      "id": "shoulder_006",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "Y5PbMAMEwpk",
      "titles": {
        "en": "Isometric Internal Rotation",
        "hi": "आइसोमेट्रिक इंटरनल रोटेशन",
        "gu": "આઇસોમેટ્રિક ઇન્ટરનલ રોટેશન"
      },
      "descriptions": {
        "en": "Stand in a doorway. With elbow at 90 degrees, press your palm into the doorframe as if moving it toward your belly.",
        "hi": "दरवाजे पर खड़े हों। कोहनी 90 डिग्री पर रखकर अपनी हथेली को दरवाजे के फ्रेम में दबाएं, जैसे कि उसे पेट की ओर ला रहे हों।",
        "gu": "દરવાજાની વચ્ચે ઉભા રહો. કોણી 90 ડિગ્રી પર રાખીને તમારી હથેળીને દરવાજાની ફ્રેમ પર દબાવો, જાણે કે તેને પેટ તરફ લાવી રહ્યા હોય."
      },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Strengthens the Subscapularis, the largest rotator cuff muscle.",
      "reps": "10",
      "sets": "2",
      "holdTime": "5-10 seconds",
      "caution": "Keep your wrist straight; do not bend it to apply pressure."
    },
    {
      "id": "shoulder_007",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "EQfE9waXdLU",
      "titles": {
        "en": "Scapular Setting (Squeezes)",
        "hi": "स्कैपुलर सेटिंग (स्क्वीज़)",
        "gu": "સ્કેપુલર સેટિંગ (સ્ક્વીઝ)"
      },
      "descriptions": {
        "en": "Squeeze your shoulder blades together and down. Imagine trying to hold a pencil between your blades.",
        "hi": "अपने कंधे के ब्लेड को एक साथ और नीचे सिकोड़ें। कल्पना करें कि आप अपने ब्लेड के बीच एक पेंसिल पकड़ने की कोशिश कर रहे हैं।",
        "gu": "તમારા ખભાના હાડકાંને એકસાથે અને નીચેની તરફ સ્ક્વીઝ કરો. કલ્પના કરો કે તમે બે હાડકાં વચ્ચે પેન્સિલ પકડવાનો પ્રયાસ કરી રહ્યા છો."
      },
      "targetSymptoms": ["Fatigue", "Weakness", "Dull Ache"],
      "clinicalBenefit": "Provides a stable base for the shoulder; prevents impingement.",
      "reps": "15",
      "sets": "3",
      "holdTime": "5 seconds",
      "caution": "Do not shrug your shoulders up toward your ears."
    },
    {
      "id": "shoulder_008",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "pgsPQ1_5e0w",
      "titles": {
        "en": "Towel Slides (Table Slides)",
        "hi": "तौलिया स्लाइड्स (टेबल स्लाइड्स)",
        "gu": "ટુવાલ સ્લાઇડ્સ (ટેબલ સ્લાઇડ્સ)"
      },
      "descriptions": {
        "en": "Sit at a table with a towel under your hand. Slide the towel forward as far as possible, then slide it back.",
        "hi": "हाथ के नीचे तौलिया रखकर मेज पर बैठें। तौलिये को जितना हो सके आगे स्लाइड करें, फिर वापस स्लाइड करें।",
        "gu": "હાથની નીચે ટુવાલ રાખીને ટેબલ પર બેસો. ટુવાલને બને તેટલો આગળ સ્લાઇડ કરો, પછી પાછો ખેંચો."
      },
      "targetSymptoms": ["Stiffness", "Limited Motion"],
      "clinicalBenefit": "Assisted active-range-of-motion (AAROM) for shoulder flexion.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Ensure the movement is smooth and controlled."
    },
    {
      "id": "shoulder_009",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "TOCcgbqzq5g",
      "titles": {
        "en": "Cross-Body Stretch",
        "hi": "क्रॉस-बॉडी स्ट्रेच",
        "gu": "ક્રોસ-બોડી સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Pull your affected arm across your chest using your other arm. Hold the stretch below the elbow.",
        "hi": "अपने दूसरे हाथ का उपयोग करके अपने प्रभावित हाथ को अपनी छाती के आर-पार खींचें। कोहनी के नीचे से पकड़ें।",
        "gu": "તમારા બીજા હાથનો ઉપયોગ કરીને અસરગ્રસ્ત હાથને તમારી છાતીની આરપાર ખેંચો. કોણીની નીચેથી પકડી રાખો."
      },
      "targetSymptoms": ["Stiffness", "Dull Ache"],
      "clinicalBenefit": "Stretches the posterior deltoid and the back of the shoulder capsule.",
      "reps": "3",
      "sets": "1",
      "holdTime": "30 seconds",
      "caution": "Do not pull on the elbow joint itself; pull on the upper arm."
    },
    {
      "id": "shoulder_010",
      "targetBodyPart": "Shoulder",
      "category": "Rotator Cuff & Scapular Stability",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "ja_P3YhmAlE",
      "titles": {
        "en": "Shoulder Shrugs (Controlled)",
        "hi": "शोल्डर श्रग्स (नियंत्रित)",
        "gu": "શોલ્ડર શ્રગ્સ (નિયંત્રિત)"
      },
      "descriptions": {
        "en": "Lift your shoulders toward your ears, hold briefly, and then slowly lower them down as far as they go.",
        "hi": "अपने कंधों को अपने कानों की ओर उठाएं, थोड़ी देर रुकें, और फिर धीरे-धीरे उन्हें जितना हो सके नीचे ले जाएं।",
        "gu": "તમારા ખભાને કાન તરફ ઊંચકો, થોડીવાર પકડી રાખો અને પછી ધીમે ધીમે તેમને બને તેટલા નીચે ઉતારો."
      },
      "targetSymptoms": ["Fatigue", "Weakness"],
      "clinicalBenefit": "Improves circulation and releases tension in the Upper Trapezius.",
      "reps": "15",
      "sets": "2",
      "holdTime": "2 seconds",
      "caution": "Focus on the 'lowering' phase; it should be slow."
    },

    {
      "id": "neck_001",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 6,
      "youtubeId": "7rnlAVhAK-8",
      "titles": {
        "en": "Chin Tucks (Cervical Retraction)",
        "hi": "चिन टक्स (गर्दन का खिंचाव)",
        "gu": "ચીન ટક્સ (ગળાનું ખેંચાણ)"
      },
      "descriptions": {
        "en": "Sit tall and look straight ahead. Without tilting your head down, draw your chin straight back as if making a double chin.",
        "hi": "सीधे बैठें और सामने देखें। अपने सिर को नीचे झुकाए बिना, अपनी ठुड्डी को सीधे पीछे खींचें जैसे कि आप डबल चिन बना रहे हों।",
        "gu": "સીધા બેસો અને સામે જુઓ. તમારા માથાને નીચે નમાવ્યા વિના, તમારી રામરામને સીધી પાછળ ખેંચો જાણે કે ડબલ ચીન બનાવી રહ્યા હોય."
      },
      "targetSymptoms": ["Forward Head Posture", "Tech Neck", "Dull Ache"],
      "clinicalBenefit": "Strengthens deep cervical flexors and decompresses the upper neck joints.",
      "reps": "10 repetitions",
      "sets": "2 sets",
      "holdTime": "5 seconds",
      "caution": "Do not tilt the head up or down; keep eyes level with the horizon."
    },
    {
      "id": "neck_002",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 7,
      "youtubeId": "r0eoFS7_5Q",
      "titles": {
        "en": "Upper Trapezius Stretch",
        "hi": "अपर ट्रेपेज़ियस स्ट्रेच",
        "gu": "અપર ટ્રેપેઝિયસ સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Sit on your right hand to anchor the shoulder. Use your left hand to gently pull your head toward the left shoulder.",
        "hi": "कंधे को स्थिर करने के लिए अपने दाहिने हाथ पर बैठें। अपने सिर को बाएं कंधे की ओर धीरे से खींचने के लिए बाएं हाथ का उपयोग करें।",
        "gu": "ખભાને સ્થિર કરવા માટે તમારા જમણા હાથ પર બેસો. તમારા માથાને ડાબા ખભા તરફ ધીમેથી ખેંચવા માટે ડાબા હાથનો ઉપયોગ કરો."
      },
      "targetSymptoms": ["Shoulder Tension", "Neck Stiffness", "Headache"],
      "clinicalBenefit": "Relieves tension in the muscle that connects the neck to the shoulder blade.",
      "reps": "3 repetitions per side",
      "sets": "1 set",
      "holdTime": "20-30 seconds",
      "caution": "Keep the anchored shoulder down; do not pull aggressively."
    },
    {
      "id": "neck_003",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "GSoXPJRnR6E",
      "titles": {
        "en": "Levator Scapulae Stretch",
        "hi": "लिवेटर स्कैपुला स्ट्रेच",
        "gu": "લિવેટર સ્કેપુલા સ્ટ્રેચ"
      },
      "descriptions": {
        "en": "Rotate your head 45 degrees to the right and look down toward your armpit. Use your hand to gently pull your head downward.",
        "hi": "अपने सिर को दाहिनी ओर 45 डिग्री घुमाएं और अपनी बगल की ओर नीचे देखें। अपने हाथ से सिर को धीरे से नीचे की ओर खींचें।",
        "gu": "તમારા માથાને જમણી બાજુ 45 ડિગ્રી ફેરવો અને તમારી બગલ તરફ નીચે જુઓ. તમારા હાથથી માથાને ધીમેથી નીચેની તરફ ખેંચો."
      },
      "targetSymptoms": ["Sharp Pain at Neck Base", "Localized Knots"],
      "clinicalBenefit": "Targets the specific muscle responsible for 'stiff neck' upon waking.",
      "reps": "3 repetitions per side",
      "sets": "1 set",
      "holdTime": "20-30 seconds",
      "caution": "Stop if you feel any pinching in the spine."
    },
    {
      "id": "neck_004",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "PruXF-NE2zI",
      "titles": {
        "en": "Cervical Rotation",
        "hi": "सर्वाइकल रोटेशन (गर्दन घुमाना)",
        "gu": "સર્વાઇકલ રોટેશન (ગળું ફેરવવું)"
      },
      "descriptions": {
        "en": "Slowly turn your head to the right as far as comfortable. Return to center and repeat on the left.",
        "hi": "धीरे-धीरे अपने सिर को दाईं ओर जितना आरामदायक हो घुमाएं। वापस बीच में आएं और बाईं ओर दोहराएं।",
        "gu": "ધીમે ધીમે તમારા માથાને જમણી બાજુ જેટલું અનુકૂળ હોય તેટલું ફેરવો. પાછા વચ્ચે આવો અને ડાબી બાજુ પુનરાવર્તન કરો."
      },
      "targetSymptoms": ["Limited Range of Motion", "Stiffness"],
      "clinicalBenefit": "Restores horizontal mobility and lubricates the facet joints.",
      "reps": "10 repetitions",
      "sets": "2 sets",
      "holdTime": "2 seconds",
      "caution": "Move slowly; avoid jerky movements."
    },
    {
      "id": "neck_005",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "UUXUVFQS5u0",
      "titles": {
        "en": "Cervical Side Flexion",
        "hi": "सर्वाइकल साइड फ्लेक्सन",
        "gu": "સર્વાઇકલ સાઇડ ફ્લેક્સન"
      },
      "descriptions": {
        "en": "Lower your right ear toward your right shoulder without lifting your shoulder. Repeat on the left.",
        "hi": "बिना कंधा उठाए अपने दाहिने कान को अपने दाहिने कंधे की ओर झुकाएं। बाईं ओर भी यही दोहराएं।",
        "gu": "ખભા ઊંચક્યા વિના તમારા જમણા કાનને તમારા જમણા ખભા તરફ નમાવો. ડાબી બાજુ પણ આ જ પુનરાવર્તન કરો."
      },
      "targetSymptoms": ["Side Neck Pain", "Stiffness"],
      "clinicalBenefit": "Improves lateral flexibility of the cervical spine.",
      "reps": "10 repetitions",
      "sets": "2 sets",
      "holdTime": "3 seconds",
      "caution": "Do not rotate the head; keep the face pointing forward."
    },
    {
      "id": "neck_006",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 4,
      "youtubeId": "QN1oZVMMRjE",
      "titles": {
        "en": "Scapular Squeezes",
        "hi": "स्कैपुलर स्क्वीज़",
        "gu": "સ્કેપુલર સ્ક્વીઝ"
      },
      "descriptions": {
        "en": "Squeeze your shoulder blades together and slightly downward, as if tucking them into your back pockets.",
        "hi": "अपने कंधे की हड्डियों (शोल्डर ब्लेड्स) को एक साथ and थोड़ा नीचे की ओर सिकोड़ें, जैसे उन्हें अपनी पिछली जेब में डाल रहे हों।",
        "gu": "તમારા ખભાના હાડકાંને એકસાથે અને સહેજ નીચેની તરફ સ્ક્વીઝ કરો, જાણે તેમને તમારી પાછળના ખિસ્સામાં નાખી રહ્યા હોય."
      },
      "targetSymptoms": ["Rounded Shoulders", "Upper Back Pain"],
      "clinicalBenefit": "Corrects the postural foundation of the neck.",
      "reps": "15 repetitions",
      "sets": "2 sets",
      "holdTime": "5 seconds",
      "caution": "Do not shrug your shoulders up toward your ears."
    },
    {
      "id": "neck_007",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "3Owy1hurobA",
      "titles": {
        "en": "Isometric Neck Side Flexion",
        "hi": "आइसोमेट्रिक नेक साइड फ्लेक्सन",
        "gu": "આઇસોમેટ્રિક નેક સાઇડ ફ્લેક્સન"
      },
      "descriptions": {
        "en": "Place your palm on the side of your head. Try to tilt your head toward your shoulder while resisting the movement with your hand.",
        "hi": "अपनी हथेली को अपने सिर के किनारे रखें। अपने हाथ से विरोध करते हुए अपने सिर को कंधे की ओर झुकाने की कोशिश करें।",
        "gu": "તમારી હથેળીને તમારા માથાની બાજુ પર રાખો. તમારા હાથથી પ્રતિકાર કરતી વખતે તમારા માથાને ખભા તરફ નમાવવાનો પ્રયાસ કરો."
      },
      "targetSymptoms": ["Weakness", "Instability"],
      "clinicalBenefit": "Builds neck strength without putting stress on the discs.",
      "reps": "5 repetitions per side",
      "sets": "1 set",
      "holdTime": "5 seconds",
      "caution": "Keep the neck in a neutral, straight position."
    },
    {
      "id": "neck_008",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Intermediate",
      "maxPainScore": 6,
      "youtubeId": "tbNtU66KzmE",
      "titles": {
        "en": "Isometric Neck Rotation",
        "hi": "आइसोमेट्रिक नेक रोटेशन",
        "gu": "આઇસોમેટ્રિક નેક રોટેશન"
      },
      "descriptions": {
        "en": "Place your hand on your temple. Attempt to turn your head to look over your shoulder while resisting with your hand.",
        "hi": "अपना हाथ अपनी कनपटी पर रखें। अपने हाथ से विरोध करते हुए अपने कंधे के ऊपर देखने के लिए सिर घुमाने का प्रयास करें।",
        "gu": "તમારો હાથ તમારી કનપટ્ટી પર રાખો. તમારા હાથથી પ્રતિકાર કરતી વખતે તમારા ખભા પર જોવા માટે માથું ફેરવવાનો પ્રયાસ કરો."
      },
      "targetSymptoms": ["Pain during movement", "Instability"],
      "clinicalBenefit": "Provides stability training for the rotational muscles.",
      "reps": "5 repetitions per side",
      "sets": "1 set",
      "holdTime": "5 seconds",
      "caution": "Apply only 20-30% of your maximum strength."
    },
    {
      "id": "neck_009",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 8,
      "youtubeId": "p8-pJ1A-stk",
      "titles": {
        "en": "Suboccipital Release (Self-Massage)",
        "hi": "सबऑक्सीपिटल रिलीज़ (स्व-मालिश)",
        "gu": "સબઓક્સિપિટલ રિલીઝ (સ્વ-માલિશ)"
      },
      "descriptions": {
        "en": "Place your thumbs at the base of your skull where it meets the neck. Apply gentle upward pressure while tucking your chin.",
        "hi": "अपने अंगूठों को अपनी खोपड़ी के निचले हिस्से पर रखें जहाँ वह गर्दन से मिलती है। ठुड्डी को अंदर दबाते हुए हल्का ऊपर की ओर दबाव डालें।",
        "gu": "તમારા અંગૂઠાને તમારી ખોપરીના નીચેના ભાગમાં રાખો જ્યાં તે ગરદન સાથે મળે છે. રામરામને અંદર દબાવતી વખતે હળવું ઉપરની તરફ દબાણ આપો."
      },
      "targetSymptoms": ["Tension Headache", "Pain at Base of Skull"],
      "clinicalBenefit": "Inhibits overactive muscles that cause tension headaches.",
      "reps": "1 repetition",
      "sets": "N/A",
      "holdTime": "60 seconds",
      "caution": "Apply pressure to muscle, not directly on the spine."
    },
    {
      "id": "neck_010",
      "targetBodyPart": "Head & Neck",
      "category": "Cervical Spine & Suboccipital",
      "level": "Beginner",
      "maxPainScore": 5,
      "youtubeId": "8QCjZMdcIpc",
      "titles": {
        "en": "Neck Semicircles",
        "hi": "नेक सेमीसर्कल्स (गर्दन का अर्धवृत्त)",
        "gu": "નેક સેમીસર્કલ (ગળાનું અર્ધવર્તુળ)"
      },
      "descriptions": {
        "en": "Drop your chin to your chest. Slowly roll your head in a 'U' shape from one shoulder to the other.",
        "hi": "अपनी ठुड्डी को अपनी छाती पर झुकाएं। धीरे-धीरे अपने सिर को एक कंधे से दूसरे कंधे तक 'U' आकार में घुमाएं।",
        "gu": "તમારી રામરામને તમારી છાતી પર નમાવો. ધીમે ધીમે તમારા માથાને એક ખભાથી બીજા ખભા સુધી 'U' આકારમાં ફેરવો."
      },
      "targetSymptoms": ["General Stiffness", "Crunching Sound"],
      "clinicalBenefit": "Provides a gentle dynamic stretch to all posterior neck muscles.",
      "reps": "10 repetitions",
      "sets": "1 set",
      "holdTime": "Flowing",
      "caution": "Do not roll your head backward (full circles) as this can compress arteries."
    }

  ];

  // 2. The Auto-Upload Function
  static Future<void> uploadAllExercises(BuildContext context) async {
    try {
      // Show a loading snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploading to Firebase... Please wait.")),
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Loop through the list and upload each one
      for (var ex in exercises) {
        await firestore.collection('exercises').doc(ex['id']).set(ex);
      }

      // Success!
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ All exercises uploaded successfully!")),
        );
      }
      print("DATABASE UPLOAD COMPLETE!");

    } catch (e) {
      print("Error uploading: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
}