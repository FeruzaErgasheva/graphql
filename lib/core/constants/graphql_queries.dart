const String fetchProducts = """
query{
  products{
    id
    title
    images
    price
    description
    category{
      name
    }
  }
}
""";
