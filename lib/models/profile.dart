import 'package:flutter/foundation.dart';

class Profile{
  Name? name;
  Location? location;
  String? email;
  DateOfBirth? dob;
  Registered? registered;
  Picture? image;

  Profile({this.name, this.location, this.email,this.dob,this.registered, this.image});

  Profile.fromJson(dynamic json){
    if(json?["results"] != null && json["results"].isNotEmpty){
      final result = json["results"][0];
      if(result["name"] != null){
        name = Name.fromJson(result["name"]);
      }
      if (result["location"] != null) {
        location = Location.fromJson(result["location"]);
      }
      email = result["email"];

      if (result["dob"] != null) {
        dob = DateOfBirth.fromJson(result["dob"]);
      }

      if (result["registered"] != null) {
        registered = Registered.fromJson(result["registered"]);
      }
      if (result["picture"] != null) {
        image = Picture.formJson(result["picture"]);
      }
    }
  }
}

void printToConsole(Object? object){
  if(kDebugMode){
    print(object);
  }
}

class Name{
  String? title;
  String? firstName;
  String? lastName;

  Name({this.title, this.firstName, this.lastName});

  String getFullName(){
    String fullName = "";
    if(firstName?.isNotEmpty ?? false){
      if(title != null){
        fullName = "$fullName$title.";
      }
      if(firstName?.isNotEmpty ?? false){
        fullName = "$fullName $firstName";
      }
      if(firstName?.isNotEmpty ?? false){
        fullName = "$fullName $lastName";
      }
    }
    return fullName.isNotEmpty ? fullName : "No Name Found!";
  }

  Name.fromJson(dynamic json){
    if(json != null){
      try {
        title = json["title"];
        firstName = json["first"];
        lastName = json["last"];
      } catch (e) {
        printToConsole("Exception while Parsing name: ${e.toString()}");
      }
    }
  }
}

class Location{
  Street? street;
  String? city;
  String? state;
  String? country;
  num? postcode;
  Coordinates? coordinates;
  Timezone? timezone;

  Location({this.street, this.city, this.state, this.country, this.postcode, this.coordinates, this.timezone});

  Location.fromJson(dynamic json){
    if(json != null){
      try {
        if (json["street"] != null) {
          street = Street.fromJson(json["street"]);
        }
        city = json["city"];
        state = json["state"];
        country = json["country"];
        postcode = num.tryParse(json["postcode"].toString());
        if (json["coordinates"] != null) {
          coordinates = Coordinates.fromJson(json["coordinates"]);
        }
        if(json["timezone"] != null){
          timezone = Timezone.formJson(json["timezone"]);
        }
      } catch (e) {
        printToConsole("Exception while parding location: ${e.toString()}");
      }
    }
  }

}

class Street{
  num? number;
  String? name;

  Street({this.number, this.name});

  Street.fromJson(dynamic json){
    if(json != null){
      try {
        number = num.tryParse(json["number"]?.toString() ?? "");
        name = json["name"];
      }  catch (e) {
        printToConsole("Exception while parsing Street: ${e.toString()}");
      }
    }
  }

  String streetString(){
    final street = "${number != null ? "$number, ": ""}${name ?? ""}";
    return street.isNotEmpty ? street : "N/A";
  }
}

class Coordinates{
  num? latitude;
  num? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(dynamic json){
    if(json != null){
      try {
        latitude = num.tryParse(json["latitude"]?.toString() ?? "");
        longitude = num.tryParse(json["longitude"]?.toString() ?? "");
      } catch (e) {
        printToConsole("Exception while parsing Coordinates: ${e.toString()}");
      }
    }
  }
}

class Timezone{
  String? offset;
  String? description;

  Timezone({this.offset, this.description});

  Timezone.formJson(dynamic json){
    if(json != null){
      try {
        offset = json["offset"];
        description = json["description"];
      } catch (e) {
        printToConsole("Exception while parsing Timezone: ${e.toString()}");
      }
    }
  }
}

class DateOfBirth{
  String? date;
  num? age;

  DateOfBirth.fromJson(dynamic json){
    if(json != null){
      try {
        date = json["date"];
        age = num.tryParse(json["age"]?.toString() ?? "");
      } catch (e) {
        printToConsole("Exception while parsing DateOfBirth:${e.toString()}");
      }
    }
  }
  String? dobString(){
    if(date != null){
      final dt = DateTime.tryParse(date!);
      if(dt != null){
        return "${dt.day} ${months[dt.month-1]} ${dt.year}";
      }
    }
    return null;
  }
}

const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class Registered{
  String? date;
  num? age;

  Registered.fromJson(dynamic json){
    if(json != null){
      try {
        date = json["date"];
        age = num.tryParse(json["age"]?.toString() ?? "");
      } catch (e) {
        printToConsole("Exception while parsing Registered:${e.toString()}");
      }
    }
  }

  num? numberOfDaysSinceRegistered(){
    if(date != null){
      final dt = DateTime.tryParse(date!);
      if(dt != null){
        return DateTime.now().difference(dt).inDays;
      }
    }
    return null;
  }
}

class Picture{
  String? large;
  String? medium;
  String? thumbnail;

  Picture({this.large, this.medium, this.thumbnail});

  Picture.formJson(dynamic json){
    if(json != null){
      try {
        large = json["large"];
        medium = json["medium"];
        thumbnail = json["thumbnail"];
      } catch (e) {
        printToConsole("Exception while parsing Picture:${e.toString()}");
      }
    }
  }
}