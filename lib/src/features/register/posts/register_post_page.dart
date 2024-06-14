import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/register/posts/register_post_vm.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

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
  RegisterPostVm? vm;
  @override
  void initState() {
    vm = RegisterPostVm(spaceModel: widget.spaceModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterPostVm vm = RegisterPostVm(spaceModel: widget.spaceModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          CustomTextformfield(
            label: 'Título',
            controller: vm.tituloEC,
            validator: vm.validate(),
          ),
          CustomTextformfield(
            label: 'Descrição',
            controller: vm.descricaoEC,
            validator: vm.validate(),
          ),
          ElevatedButton(
            onPressed: () {
              vm.pickImages();
            },
            child: const Text('Escolher imagens'),
          ),
        ],
      ),
    );
  }
}
