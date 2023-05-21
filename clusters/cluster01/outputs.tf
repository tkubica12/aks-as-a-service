resource "local_file" "runtime" {
  content  = module.aks.runtime
  filename = "runtime.yaml"
}