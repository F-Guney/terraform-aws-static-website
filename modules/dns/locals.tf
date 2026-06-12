locals {
  records = {
    for pair in setproduct(var.aliases, ["A", "AAA"]) :
    "${pair[0]}.${pair[1]}" => { name = pair[0], type = pair[1] }
  }
}
