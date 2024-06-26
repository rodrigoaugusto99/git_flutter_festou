import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/features/register/posts/register_post_vm.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:svg_flutter/svg.dart';

class RegisterPostPage extends StatefulWidget {
  final SpaceModel spaceModel;
  const RegisterPostPage({
    super.key,
    required this.spaceModel,
  });

  @override
  State<RegisterPostPage> createState() => _RegisterPostPageState();
}

class _RegisterPostPageState extends State<RegisterPostPage> {
  late RegisterPostVm vm;
  @override
  void initState() {
    vm = RegisterPostVm(spaceModel: widget.spaceModel);
    vm.addListener(onViewModelChanged);
    super.initState();
  }

  @override
  void dispose() {
    vm.removeListener(onViewModelChanged);
    super.dispose();
  }

  void onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // RegisterPostVm vm = RegisterPostVm(spaceModel: widget.spaceModel);

    log(vm.photoShowing.toString());
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // gradient: LinearGradient(
          //   colors: [
          //     const Color(0xff9747FF).withOpacity(1),
          //     const Color(0xff4300B1).withOpacity(1),
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //todo: opcao de capa de post (colocar no index 0 do array)
            //todo:p isso, exibir miniaturas em listview hori. e cover icon por cima aonde clicar, sinalizand.
            CustomTextformfield(
              label: 'Nome',
              controller: vm.tituloEC,
              validator: vm.validate(),
            ),
            /*
                  os textfields, ao serem clicados, abrira um dialog com o campo a ser
                  preenchido e os botoes cancelar e salvar. Ao salvar, o texto vai aparecer 
                  no espaco abaixo, aparecendo botao de editar. titulo obrigatorio apenas
                   */
            const SizedBox(height: 15),
            CustomTextformfield(
              label: 'Descrição',
              controller: vm.descricaoEC,
              validator: vm.validate(),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: vm.register,
              child: Container(
                  alignment: Alignment.center,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff9747FF),
                        Color(0xff44300b1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Text(
                    'Publicar',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Form(
        key: vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //todo: quadrado grande com foto no meio
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
              child: decContainer(
                onTap: vm.pickImages,
                allPadding: 10,
                height: MediaQuery.of(context).size.height / 3,
                color: const Color(0xff9747FF).withOpacity(0.3),
                radius: 10,
                child: vm.photoShowing == null
                    ? decContainer(
                        color: const Color(0xffF2F2F2),
                        radius: 25,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            decContainer(
                              height: 90,
                              width: 90,
                              radius: 100,
                              color: Colors.white,
                              allPadding: 10,
                              child: SvgPicture.asset(
                                'lib/assets/images/Groupcamerah.svg',
                                color: const Color(0xff4300B1),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Image.file(
                            vm.photoShowing!,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 0,
                            child: decContainer(
                              height: 90,
                              width: 90,
                              radius: 100,
                              color: Colors.white.withOpacity(0.6),
                              allPadding: 10,
                              child: SvgPicture.asset(
                                'lib/assets/images/Groupcamerah.svg',
                                color: const Color(0xff4300B1),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (vm.imagesToRegister.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text('Escolha sua foto de capa'),
              ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.imagesToRegister.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          decContainer(
                            onTap: () => vm.onPhotoTap(index),
                            height: 100,
                            width: 100,
                            radius: 10,
                            color: Colors.grey[400],
                            allPadding: 7,
                            child: decContainer(
                              radius: 10,
                              color: Colors.red,
                              child: Image.file(
                                vm.imagesToRegister[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (vm.photoShowing == vm.imagesToRegister[index])
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.photo,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                decContainer(
                                  radius: 10,
                                  color: Colors.black.withOpacity(0.5),
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: decContainer(
                              onTap: () => vm.deletarImagem(index),
                              radius: 50,
                              color: Colors.red,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
