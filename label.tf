
# frigga naming rule
locals {
  name = join("-", compact(["spinnaker", "managed", var.desc]))
}