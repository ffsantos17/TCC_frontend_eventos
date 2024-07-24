import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../config/app_colors.dart';

class DetalhesEvento extends StatefulWidget {
  const DetalhesEvento({super.key});

  @override
  State<DetalhesEvento> createState() => _DetalhesEventoState();
}

class _DetalhesEventoState extends State<DetalhesEvento> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) // <--- border radius here
                      ),
                    ),
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.network(
                          'https://digipaper.com.br/wp-content/uploads/2019/01/2018_05_04.jpg',
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(.5),
                          height: screenSize.height * 0.55,
                          width: screenSize.width,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 20,
                    child: Text(
                      "  20º Congresso Nacional de programação  ",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: AppColors.mainBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 32),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Descrição",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.5,
                            color: Color(0xFF4A709C),
                          ),
                        ),
                      SizedBox(height: 5,),
                      Text(
                          "O Lorem Ipsum é um texto modelo da indústria tipográfica e de impressão. O Lorem Ipsum tem vindo a ser o texto padrão usado por estas indústrias desde o ano de 1500, quando uma misturou os caracteres de um texto para criar um espécime de livro. Este texto não só sobreviveu 5 séculos, mas também o salto para a tipografia electrónica, mantendo-se essencialmente inalterada. Foi popularizada nos anos 60 com a disponibilização das folhas de Letraset, que continham passagens com Lorem Ipsum, e mais recentemente com os programas de publicação como o Aldus PageMaker que incluem versões do Lorem Ipsum",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                      SizedBox(height: 5,),
                      Divider(),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                                Text(
                                  DateTime.now().semanaDiaMesAnoExt().toString().capitalize(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Local",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                                Text(
                                  "Recife-PE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Divider(),
                      SizedBox(height: 5,),
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vagas",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                                Text(
                                  "1000",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vagas Disponieis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                                Text(
                                  "50",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(16, 0, 16, 32),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              //         width: 456,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Color(0xFFCFDBE8)),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Container(
              //           padding: EdgeInsets.fromLTRB(24, 24, 0, 24),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              //                 child: Align(
              //                   alignment: Alignment.topLeft,
              //                   child: Container(
              //                     child:
              //                     Text(
              //                       'Total places',
              //                       style: TextStyle(
              //
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 16,
              //                         height: 1.5,
              //                         color: Color(0xFF0D141C),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Align(
              //                 alignment: Alignment.topLeft,
              //                 child: Container(
              //                   child:
              //                   Text(
              //                     '100',
              //                     style: TextStyle(
              //
              //                       fontWeight: FontWeight.w700,
              //                       fontSize: 24,
              //                       height: 1.3,
              //                       color: Color(0xFF0D141C),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: 456,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Color(0xFFCFDBE8)),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Container(
              //           padding: EdgeInsets.fromLTRB(24, 24, 0, 24),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              //                 child: Align(
              //                   alignment: Alignment.topLeft,
              //                   child: Container(
              //                     child:
              //                     Text(
              //                       'Available places',
              //                       style: TextStyle(
              //
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 16,
              //                         height: 1.5,
              //                         color: Color(0xFF0D141C),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Align(
              //                 alignment: Alignment.topLeft,
              //                 child: Container(
              //                   child:
              //                   Text(
              //                     '60',
              //                     style: TextStyle(
              //
              //                       fontWeight: FontWeight.w700,
              //                       fontSize: 24,
              //                       height: 1.3,
              //                       color: Color(0xFF0D141C),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child:
                    Text(
                      'Mandatory documents',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        height: 1.3,
                        color: Color(0xFF0D141C),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7FAFC),
                ),
                child: SizedBox(
                  width: 960,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE8EDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: 48,
                              height: 48,
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child:
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Icon(Icons.file_copy),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child:
                                  Text(
                                    'Government-issued ID',
                                    style: TextStyle(

                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 1.5,
                                      color: Color(0xFF0D141C),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child:
                                Text(
                                  'File types: .pdf, .png, .jpeg, .jpg',
                                  style: TextStyle(

                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7FAFC),
                ),
                child: SizedBox(
                  width: 960,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE8EDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: 48,
                              height: 48,
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child:
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Icon(Icons.file_copy),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child:
                                Text(
                                  'Proof of business registration',
                                  style: TextStyle(

                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Color(0xFF0D141C),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 19.3, 0),
                                child:
                                Text(
                                  'File types: .pdf, .png, .jpeg, .jpg',
                                  style: TextStyle(

                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color(0xFF4A709C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                  ),
                  child: SizedBox(
                    width: 960,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE8EDF5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                width: 48,
                                height: 48,
                                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                child:
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(Icons.file_copy),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child:
                                  Text(
                                    'Proof of website ownership',
                                    style: TextStyle(

                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 1.5,
                                      color: Color(0xFF0D141C),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 3.1, 0),
                                  child:
                                  Text(
                                    'File types: .pdf, .png, .jpeg, .jpg',
                                    style: TextStyle(

                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFF4A709C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 960,
                    child:
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF0D7DF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 480,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child:
                        Text(
                          'Register now',
                          style: TextStyle(

                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFFF7FAFC),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}