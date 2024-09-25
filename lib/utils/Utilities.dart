class Utilities {

  String checkName(String title) {
    if (title == "Nissan Frontier") {
      return "lib/assets/frontier.jpg";
    } else if (title == "Kawasaki Vulcan S") {
      return "lib/assets/motorcycle-standing.jpg";
    } else if (title == "Honda CRV") {
      return "lib/assets/2023-honda-crv.png";
    }
    return "lib/assets/frontier.jpg";
  }
}
