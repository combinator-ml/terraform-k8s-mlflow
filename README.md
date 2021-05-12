# terraform-{{ provider }}-{{ component/stack }}

{{ Insert brief overview here - this file will be injected into the README by the github action }}

## Usage

```terraform
module "{{ component/stack }}" {
  source  = "combinator-ml/{{ component/stack }}/{{ provider }}"
  version = "0.0.0"
}
```

See the full configuration options below.

## Known Issues

- {{ Known Issue 1 }}
  {{ Known Issue description }}
- ...

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| kubernetes | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | The namespace to install into. | `string` | `"default"` | no |

## Outputs

No output.
