// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:harees_new_project/Resources/Drawer/drawer.dart';
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
      backgroundColor: Colors.blue[50],

      body: Stack(
        children: [
          // Background image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png', // Ensure this path is correct
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('About Us'),
                  buildSectionText(
                    'We are a dedicated home healthcare platform that connects individuals with certified and trusted healthcare providers. Our mission is to make high-quality home care services accessible, ensuring comfort, convenience, and professional medical assistance at your doorstep.'
                  ),
                  buildSectionText(
                    'With a network of licensed nurses, physiotherapists, and healthcare professionals, we provide a wide range of services, including elderly care, post-surgery recovery, wound care, physiotherapy, and more.'
                  ),
                  buildSectionText(
                    'Our platform is designed to offer a seamless booking experience, flexible scheduling, and reliable support to meet your unique healthcare needs. Whether you need routine care or specialized medical assistance, we are here to support you every step of the way.'
                  ),
                  buildSectionText('Your health. Your home. Our care.'),
                  const SizedBox(height: 20),

                  buildSectionTitle('من نحن'),
                  buildSectionText(
                    'نحن منصة متخصصة في تقديم خدمات الرعاية الصحية المنزلية، حيث نربط الأفراد بمقدمي رعاية صحية معتمدين وموثوقين. مهمتنا هي جعل خدمات الرعاية المنزلية عالية الجودة في متناول الجميع، مما يضمن لك الراحة والعناية الطبية الاحترافية في منزلك.'
                  ),
                  buildSectionText(
                    'من خلال شبكة من الممرضين المرخصين وأخصائيي العلاج الطبيعي وغيرهم من مقدمي الرعاية الصحية، نقدم مجموعة واسعة من الخدمات، بما في ذلك رعاية كبار السن، التعافي بعد الجراحة، العناية بالجروح، العلاج الطبيعي، والمزيد.'
                  ),
                  buildSectionText(
                    'تم تصميم منصتنا لتوفير تجربة حجز سلسة، وجدولة مرنة، ودعم موثوق لتلبية احتياجاتك الصحية الفريدة. سواء كنت بحاجة إلى رعاية روتينية أو مساعدة طبية متخصصة، نحن هنا لدعمك في كل خطوة.'
                  ),
                  buildSectionText('صحتك.. في منزلك.. برعايتنا'),
                  const SizedBox(height: 20),
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
          fontSize: 22,
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
}
