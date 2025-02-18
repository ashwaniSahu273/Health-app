import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class FAQ extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const FAQ({super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'FAQ'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Frequently Asked Questions'),
              ...buildFAQList(faqData),
              const SizedBox(height: 20),
              buildSectionTitle('الأسئلة الشائعة'),
              ...buildFAQList(faqDataArabic),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color:Colors.black,
        ),
      ),
    );
  }

  List<Widget> buildFAQList(List<Map<String, String>> faqList) {
    return faqList
        .map(
          (faq) => Card(
            color: Colors.white.withOpacity(0.9),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

List<Map<String, String>> faqData = [
  {'question': 'What is this platform?', 'answer': 'Our platform connects you with certified healthcare providers, offering professional home health care services tailored to your needs.'},
  {'question': 'Are the service providers certified?', 'answer': 'Yes, all our service providers are approved and licensed by relevant health authorities.'},
  {'question': 'What services do you offer?', 'answer': 'We provide elderly care, post-surgery recovery support, wound care, physiotherapy, medical consultations, and other essential home healthcare services.'},
  {'question': 'How can I book a service?', 'answer': 'Simply register on our platform, browse available services, select the one you need, and book a provider at your preferred time.'},
  {'question': 'Can I schedule recurring visits?', 'answer': 'Yes, you can set up recurring appointments based on your healthcare needs.'},
  {'question': 'How much do the services cost?', 'answer': 'Prices vary depending on the type of service. You can check service rates on the platform before booking.'},
  {'question': 'What payment methods are accepted?', 'answer': 'We accept credit/debit cards, bank transfers, and digital payment solutions.'},
  {'question': 'Can I choose a specific caregiver?', 'answer': 'Yes, you can select from available professionals based on their profiles and customer reviews.'},
  {'question': 'Can I cancel or reschedule a booking?', 'answer': 'Yes, you can cancel or reschedule based on our policy. Fees may apply for last-minute cancellations.'},
];

List<Map<String, String>> faqDataArabic = [
  {'question': 'ما هي هذه المنصة؟', 'answer': 'منصتنا تربطك بمقدمي رعاية صحية معتمدين، حيث نوفر خدمات رعاية صحية منزلية احترافية تلبي احتياجاتك.'},
  {'question': 'هل مقدمو الخدمات معتمدون؟', 'answer': 'نعم، جميع مقدمي الخدمات لدينا معتمدون ومرخصون من الجهات الصحية المختصة.'},
  {'question': 'ما هي الخدمات التي تقدمونها؟', 'answer': 'نقدم خدمات رعاية كبار السن، دعم ما بعد العمليات الجراحية، العناية بالجروح، العلاج الطبيعي، الاستشارات الطبية، وغيرها من خدمات الرعاية الصحية المنزلية.'},
  {'question': 'كيف يمكنني حجز الخدمة؟', 'answer': 'يمكنك التسجيل في منصتنا، تصفح الخدمات المتاحة، اختيار الخدمة المطلوبة، وحجز مقدم الخدمة في الوقت الذي يناسبك.'},
  {'question': 'هل يمكنني جدولة زيارات متكررة؟', 'answer': 'نعم، يمكنك تحديد مواعيد متكررة وفقًا لاحتياجاتك الصحية.'},
  {'question': 'كم تكلفة الخدمات؟', 'answer': 'تختلف الأسعار حسب نوع الخدمة، ويمكنك الاطلاع على الأسعار قبل تأكيد الحجز.'},
  {'question': 'ما هي طرق الدفع المقبولة؟', 'answer': 'نقبل بطاقات الائتمان/الخصم، التحويلات البنكية، والحلول الرقمية للدفع.'},
  {'question': 'هل يمكنني اختيار مقدم رعاية محدد؟', 'answer': 'نعم، يمكنك اختيار مقدم الخدمة المناسب بناءً على ملفه الشخصي وتقييمات العملاء.'},
  {'question': 'هل يمكنني إلغاء أو إعادة جدولة الحجز؟', 'answer': 'نعم، يمكنك الإلغاء أو إعادة الجدولة وفقًا لسياستنا. قد يتم فرض رسوم على الإلغاء المتأخر.'},
];
