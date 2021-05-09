package terraform.analysis
import input as tfplan

has_acceptable_greeting {
  greeting := input.variables["greeting"]

  contains(greeting.value, "goodbye") != true
}
