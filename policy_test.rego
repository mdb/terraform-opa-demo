package terraform.analysis

test_acceptable_greeting {
  has_acceptable_greeting with input as {"variables": {"greeting": {"value": "hello"}}}
}

test_inacceptable_greeting {
  not has_acceptable_greeting with input as {"variables": {"greeting": {"value": "goodbye"}}}
}

test_inacceptable_verbose_greeting {
  not has_acceptable_greeting with input as {"variables": {"greeting": {"value": "foo goodbye bar"}}}
}
