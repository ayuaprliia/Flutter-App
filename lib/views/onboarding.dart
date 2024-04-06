// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/greeting.dart';

//menambahkan list agar gambar, judul, dan deskripsi dapat berubah ketika page di-slide
List onboardingData = [
  {
    "image":"assets/images/onBoarding1.png",
    "title":"Kemudahan Akses\nBelajar Bahasa Isyarat",
    "description":"Selamat Datang di Signify!",
  },
  {
    "image":"assets/images/onBoarding2.png",
    "title":"Belajar Bahasa Isyarat\nyang Menyenangkan",
    "description":"Banyak materi dengan berbagai kategori!",
  },
  {
    "image":"assets/images/onBoarding3.png",
    "title":"Tidak Ada Batasan\nuntuk Berkomunikasi",
    "description":"Belajar BISINDO bersama Signify!",
  },
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
   State<OnboardingView> createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnboardingView> {
  //menambahkan page controller dengan menginisiasi variabel currentPage yang diset dengan nilai awal  0
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //dibungkus dengan expanded untuk memberikan pemisah dengan kolom button
            Expanded(
              //widget Pageview.builder untuk menampilkan onboarding page yang nantinya bisa dislide 
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value){
                  // print(value.toString()); (mengecek indeks halaman)
                  setState(() {
                  currentPage = value;                    
                  });
                },
                
                //membuat halaman onboarding dengan mengakses data yang sudah dibuat di List onboardingData. itemCount digunakan untuk menghitung panjang dari onboardingData
                itemCount: onboardingData.length,
                itemBuilder: (_,i){  //membangun widget yang akan ditampilkan di dalam PageView
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset(onboardingData[i]['image']),
                  Column(
                    children: [
                        Text(
                        onboardingData[i]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: "PoppinsBold", fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Text(
                          onboardingData[i]['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "PoppinsMedium", fontSize: 16, color: fontGrayColor),
                        ),
                      ),
                    ],
                  ),
                  ],
                );
              }),
            ),
           
           //Membuat indikator
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: currentPage == 0 ? blueColor : grayColor, 
                          borderRadius: BorderRadius.circular(10)),
                          height: 8,
                          width: currentPage == 0 ? 25 : 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: currentPage == 1 ? blueColor : grayColor, 
                          borderRadius: BorderRadius.circular(10)),
                          height: 8,
                          width: currentPage == 1 ? 25 : 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: currentPage == 2 ? blueColor : grayColor, 
                          borderRadius: BorderRadius.circular(10)),
                          height: 8,
                          width: currentPage == 2 ? 25 : 8,
                      ),
                    ],
                  ),
                ),

              //membuat button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(currentPage!= 2)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 65),
                          child: GestureDetector(
                            onTap: () {
                              // Mengarahkan ke halaman selanjutnya jika mengklik tombol Lewati/Masuk
                              pageController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                 "Lewati",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if(currentPage!= 2)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 65),
                          child: GestureDetector(
                            onTap: () {
                              // Mengarahkan ke halaman selanjutnya jika mengklik tombol Daftar/Selanjutnya
                              pageController.animateToPage(
                                currentPage+1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: blueColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                 "Selanjutnya",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      if (currentPage == 2)
                      Expanded(
                        child: 
                        Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 65),
                            child: GestureDetector(
                             onTap: (){

                              //menavigasi atau melemparkan halaman onboarding ke halaman greeting
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const GreetingView()));
                             },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                color:blueColor, 
                                borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Text(
                                  "Mulai Sekarang",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "PoppinsSemiBold",
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                       )
                      ],
                    ),
                  ),
                ),              
              ],
            ),
          ],
        ),
      ),
    );
  }
}