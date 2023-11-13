import 'package:flutter/material.dart';

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});

  @override
  _DadosPageState createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage> {
  bool isEditing = false;

  TextEditingController nameController =
      TextEditingController(text: "Nome do Usuário");
  TextEditingController emailController =
      TextEditingController(text: "usuario@example.com");
  TextEditingController phoneController =
      TextEditingController(text: "(123) 456-7890");
  TextEditingController cepController =
      TextEditingController(text: "12345-678");
  TextEditingController addressController =
      TextEditingController(text: "Rua da Amostra, 123");
  TextEditingController numberController = TextEditingController(text: "123");
  TextEditingController neighborhoodController =
      TextEditingController(text: "Bairro da Amostra");
  TextEditingController cityController =
      TextEditingController(text: "Cidade Amostra");
  TextEditingController spacesController =
      TextEditingController(text: "Espaços Cadastrados");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil de Usuário"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField("Nome", nameController),
              buildTextField("Email", emailController),
              Row(
                children: [
                  Expanded(child: buildTextField("Telefone", phoneController)),
                  Expanded(child: buildTextField("CEP", cepController)),
                ],
              ),
              buildTextField("Logradouro", addressController),
              buildTextField("Número", numberController),
              buildTextField("Bairro", neighborhoodController),
              buildTextField("Cidade", cityController),
              buildTextField("Espaços Cadastrados", spacesController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(isEditing ? "Salvar" : "Editar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
