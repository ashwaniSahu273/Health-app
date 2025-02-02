// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';

class AboutUsPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  
  const AboutUsPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: userModel, 
        firebaseUser: firebaseUser, 
        targetUser: userModel,
      ),

      // drawer: MyDrawer(
      //   userModel: userModel, 
      //   firebaseUser: firebaseUser, 
      //   targetUser: userModel,
      // ),

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('من نحن:'),
                  buildSectionText(
                    'منصة الكترونية متخصصة في خدمات الرعاية الصحية المنزلية مملوكة من قبل شركة سعودية، تعمل على ربط مقدمي خدمات الرعاية المنزلية بالعملاء المستفيدين، وتقديم خدمات صحية بجودة وكفاءة عالية بكل يسر وسهولة.',
                  ),
                  buildSectionTitle('رؤيتنا:'),
                  buildSectionText(
                    'تسعى منصة حريص لتمكين المرضى من الحصول على خدمات طبية في كل مكان وزمان وبجودة لا تقل عن الخدمات المقدمة في المستشفيات، لهدف زيادة جودة الحياة وتسهيل الوصول للرعاية الصحية.',
                  ),
                  buildSectionTitle('أسئلة شائعة:'),
                  buildSectionQA('هل استخدام التطبيق مجاني؟',
                      'تحميل واستخدام التطبيق مجاني بالكامل والدفع يتم عند الاستفادة من أحد الخدمات المدرجة على التطبيق، كما يمكنك الدفع مباشرة من خلال بطاقتك الائتمانية أو الدفع عند زيارة فريقنا لك.'),
                  buildSectionQA('هل تقبلون شركات التأمين؟',
                      'نعم نقبل شركات التأمين التالية: ...'),
                  buildSectionQA('كم مدة الاستشارة؟',
                      'مدة الاستشارة ٢٠ دقيقة للطب النفسي وعلم النفس و ١٥ دقيقة لباقي التخصصات.'),
                  buildSectionQA('كيف يتم التواصل أثناء الاستشارة؟',
                      'من خلال مكالمة الفيديو أو المكالمة الصوتية أو الكتابة (حسب ما تقتضيه الحالة).'),
                  buildSectionQA('كيف أتمكن من الحصول على الأدوية؟',
                      'بعد انتهاء الاستشارة سيقوم الطبيب بكتابة الوصفة وتصلك من خلال التطبيق وبعدها التوجه لأقرب صيدلية لصرف الأدوية.'),
                  buildSectionQA('هل بإمكاني إعادة جدولة الموعد لوقت آخر؟',
                      'يرجى التواصل مع خدمة العملاء قبل وقت الموعد بـ ٣٠ دقيقة حتى يتم إلغاء الموعد.'),
                  buildSectionQA('أرغب بالغاء الموعد ماهي الطريقة؟',
                      'يرجى التواصل مع خدمة العملاء قبل وقت الموعد بـ ٣٠ دقيقة حتى يتم إلغاء الموعد.'),
                  buildSectionTitle('الخدمات المقدمة:'),
                  buildSectionText('• استشارة عن بعد'),
                  buildSectionText('• التحاليل الطبية'),
                  buildSectionText('• زيارة الطبيب'),
                  buildSectionText('• زيارة ممرض'),
                  buildSectionText('• الفيتامينات الوريدية'),
                  buildSectionText('• المرافقة الصحية'),
                  buildSectionText('• العلاج الطبيعي'),
                  buildSectionText('• التطعيمات'),
                  buildSectionText('• الأشعة'),
                  buildSectionText('• لقاح الإنفلونزا الموسمية'),
                  buildSectionText('• فحص كورونا'),
                  buildSectionTitle('باقات التحاليل المقدمة:'),
                  buildSectionText(
                      'الفحص الشامل: مجموعة من الفحوصات يوصى بالقيام بها بشكل دوري...'),
                  buildSectionText(
                      'باقة تساقط الشعر: مجموعة من الفحوصات المخبرية تشمل...'),
                  buildSectionText(
                      'باقة الإرهاق و التعب: يعتمد التشخيص على تقييم وضع المريض...'),
                  buildSectionText(
                      'باقة الفيتامينات: باقة الفيتامينات تساعدك على فهم احتياجات جسدك...'),
                  buildSectionText(
                      'باقة الغدة الدرقية: اختبارات متابعة وظائف الغدة الدرقية...'),
                  buildSectionTitle('التحاليل الفردية المقدمة:'),
                  buildSectionText('• فحص البروتين الكلي في البول'),
                  buildSectionText('• فحص البروتين الكلي في الدم'),
                  buildSectionText('• فحص الكوليسترول الضار (LDL)'),
                  buildSectionText('• فحص فيتامين B6'),
                  buildSectionText("• فحص حمى التيفوئيد"),
                  buildSectionText("• فحص معدل الترشيح الكلوي النسبي"),
                  buildSectionText("• اختبار الدم المختفي في البراز"),
                  buildSectionText("• تحليل مستضد البروستاتا النوعي الحر"),
                  buildSectionText("• فحص هرمون البروجسترون"),
                  buildSectionText("• تحليل كومبس الغيرمباشر"),
                  buildSectionText("• تحليل بروتينات بنس جونس في البول"),
                  buildSectionText("• اختبار مسحة افرازات مجرى البول"),
                  buildSectionText("• اختبار مزرعة البول"),
                  buildSectionText("• فحص مستوى حمض الفوليك في الجسم"),
                  buildSectionText("• فحص مستوى الليثيوم في الدم"),
                  buildSectionText("• فحص الدهون الثلاثية في الدم"),
                  buildSectionText("• تحليل البيبتيد الدماغي المدر للصوديوم"),
                  buildSectionText("• تحليل المغنيسيوم في الدم "),
                  buildSectionText("• فحص اعتلال انزيمات كريات الدم الحمراء (نقص انزيم التفول) G6PD "),
                  buildSectionText("• فحص الكورتيزول في الدم"),
                  buildSectionText("• تحليل تصفية الكرياتينين "),
                  buildSectionText("• فحص أنزيمات الكبد (ALT) "),
                  buildSectionText("• تحليل السكر التراكمي "),
                  buildSectionText("• فحص مستوى الكوليسترول في الدم "),
                  buildSectionText("• اختبار المستضد السطحي لالتهاب الكبد ب "),
                  buildSectionText("• تحليل الأجسام المضادة للنواة (ANA) "),
                  buildSectionText("• تحليل الغلوبولين المناعي IGG "),
                  buildSectionText("• فحص الكرياتينين في الدم "),
                  buildSectionText("• فحص إنزيم نازع هيدروجين اللاكتات "),
                  buildSectionText("• فحص هرمون التستوستيرون الحر "),
                  buildSectionText("• اختبار مقاومة البكتيريا العصِيّة للحمض "),
                  buildSectionText("• عدد كرات الدم البيضاء (WBC) "),
                  buildSectionText("• فحص الهرمون الموجه للغدة الكظرية ACTH "),
                  buildSectionText("• فحص الكوليسترول النافع (HDL)"),
                  buildSectionText("• فحص الأجسام المضادة لالتهاب الكبد الوبائي سي"),
                  buildSectionText("• فحص الدهون في الدم"),
                  buildSectionText("• اختبار نسبة أنزيمات الكبد (ALT) الى أنزيمات الكبد (AST)"),
                  buildSectionText("• تحليل اليوريا في الدم"),
                  buildSectionText("• تحليل حمض اليوريك في الدم"),
                  buildSectionText("• تحليل البول"),
                  buildSectionText("• اختبار الكلاميديا AG"),
                  buildSectionText("• تحليل هرمون النمو البشري"),
                  buildSectionText("• فحص مخزون الحديد في الجسم"),
                  buildSectionText("• فحص تحليل مستضد السرطان 153-3"),
                  buildSectionText("• قياس نسبة هرمون الأندروجين الذكوري"),
                  buildSectionText("• اختبار الأجسام المضادة للحمض النووي"),
                  buildSectionText("• فحص هرمون الغدة الدرقية الثلاثي (T3)"),
                  buildSectionText("• اختبار مزرعة الفطريات"),
                  buildSectionText("• تحليل تروبونين"),
                  buildSectionText("• نيتروجين اليوريا في الدم (BUN)"),
                  buildSectionText("• فحص تحليل مستضد السرطان 19.9"),
                  buildSectionText("• فحص فيتامين B9"),
                  buildSectionText("• تحليل الكالبروكتين في البراز"),
                  buildSectionText("• فحص مستوى الكالسيوم في الدم"),
                  buildSectionText("• فحص هرمون الألدوستيرون في الدم"),
                  buildSectionText("• تحليل نسبة الألبومين إلى الجلوبيولين "),
                  buildSectionText("• فحص هرمون الغدة الدرقية الرباعي الكلي (T4)"),
                  buildSectionText("• فحص هرمون اف اس اتش (FSH)"),
                  buildSectionText("• دلالة أورام الكبد (AFP)"),
                  buildSectionText("• فحص فصيلة الدم"),
                  buildSectionText("• فحص البروتين المتفاعل CRP"),
                  buildSectionText("• اختبار مونو سبوت تيست"),
                  buildSectionText("• الكشف عن فيروس الجهاز التنفسي RSV"),
                  buildSectionText("• فحص هرمون التستوستيرون الكلي"),
                  buildSectionText("• فحص فيتامين C"),
                  buildSectionText("• تحليل النحاس في الدم"),
                  buildSectionText("• تحليل مستوى البيليروبين ( الصفراء الكلية ) في الدم"),
                  buildSectionText("• تحليل السكر الصائم"),
                  buildSectionText("• اختبار الجلوبيولين في الدم"),
                  buildSectionText("• اختبار زمن البروثرومبين"),
                  buildSectionText("• تحليل الغلوبولين المناعي IGM"),
                  buildSectionText("• تحليل الحصبة IgG"),
                  buildSectionText("• تحليل الحصبة IgM"),
                  buildSectionText("• فحص بكتيريا كلوستريديام ديفيسيل"),
                  buildSectionText("• فحص بكتيريا النيسيرية"),
                  buildSectionText("• تحليل السائل المنوي"),
                  buildSectionText("• فحص الأجسام المضادة TORCH IgM"),
                  buildSectionText("• فحص الأجسام المضادة TORCH IgG"),
                  buildSectionText("• فحص مستوى البروتين الدهني منخفض الكثافة جدا  "),
                  buildSectionText("• المسحة المهبلية"),
                  buildSectionText("• فحص الهيماتوكريت"),
                  buildSectionText("• فحص الهيموجلوبين"),
                  buildSectionText("• تحليل متوسط حجم كريات الدم الحمراء"),
                  buildSectionText("• تحليل عرض توزع كريات الدم الحمراء"),
                  buildSectionText("• تحليل المستضد السرطاني المضغي"),
                  buildSectionText("• تحليل الأجسام المضادة لجرثومة التوكسوبلازما Igg"),
                  buildSectionText("• تحليل البراز"),
                  buildSectionText("• فحص معدن الكروم"),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildSectionQA(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionText(question),
        buildSectionText(answer),
      ],
    );
  }
}
