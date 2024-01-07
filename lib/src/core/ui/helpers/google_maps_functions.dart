// Função para obter a localização atual do dispositivo
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getCurrentLocation() async {
  //solicita permissão de localização do usuario
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    throw 'A permissão de localização foi negada';
  }
//se foi aceita, getCurrentPosition pra pegar a posição.
  Position position = await Geolocator.getCurrentPosition(
    //precisao desejada como high
    desiredAccuracy: LocationAccuracy.high,
  );
//converte o resultado em um objeto LatLng
  return LatLng(position.latitude, position.longitude);
}

// Função para obter o endereço a partir de COORDENADAS geográficas
Future<String> getAddressFromCoordinates(
    double latitude, double longitude) async {
  //obter lista de Placemarks correspondente as coordenadas com placemarkFromCoordinates
  //é uma lista pq dependendo do local, pode retornar mais de um endereço(se for um cruzamento)
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  //pega o primeiro item da lista
  Placemark firstPlacemark = placemarks.first;

//placemarks possui street, locality e área administrativa.
//retorna uma string desses atributos do placemark selecionado
  String address =
      "${firstPlacemark.street}, ${firstPlacemark.locality}, ${firstPlacemark.administrativeArea}";
  return address;
}

// Função para obter as coordenadas geográficas a partir de um ENDERECO
Future<LatLng> getCoordinatesFromAddress(String address) async {
  //obter a lista de Location(coordenadas) correspondente com o endereço
  List<Location> locations = await locationFromAddress(address);

//pega a primeira coordenada da lista.
  Location firstLocation = locations.first;
  /*ao retornar um objeto LatLng, você tem a vantagem de poder usar essa informação 
  diretamente como um objeto LatLng, que pode ser útil para exibir no mapa, 
  fazer cálculos ou interagir com outras bibliotecas que trabalham com objetos LatLng.*/
  LatLng coordinates = LatLng(firstLocation.latitude, firstLocation.longitude);

  return coordinates;
}
