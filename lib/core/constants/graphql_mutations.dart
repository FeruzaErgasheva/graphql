const String createProduct = """
mutation addProduct(
  \$title: String!, 
  \$price: Float!, 
  \$description: String!, 
  \$categoryId: Float!,
  \$images: [String!]!
) {
    addProduct(
      data: {
        title: \$title, 
        price:  \$price, 
        description: \$description, 
        categoryId: \$categoryId
        images: \$images
      }) {
      id
      title
      price
      description
      images
      category {
        name
      }
    }
}

""";


const String updateProduct = """
mutation updateProduct(\$id: ID!, \$changes: UpdateProductDto!) {
  updateProduct(id: \$id, changes: \$changes) {
    id
    title
    price
    description
    category {
      name
    }
  }
}
""";


const String deleteProduct = """
mutation deleteProduct(\$id: ID!) {
  deleteProduct(id: \$id)
}
""";
