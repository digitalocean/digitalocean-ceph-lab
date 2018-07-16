FROM golang:alpine
RUN apk update && apk add git
# NOTE: This is a fork of github.com/radekg/terraform-provisioner-ansible with a
# fix related to SSH keys. We should move back to upstream once the fix is
# merged.
RUN go get github.com/adamwg/terraform-provisioner-ansible

FROM hashicorp/terraform:light
RUN apk update && apk add ansible bash
COPY --from=0 /go/bin/terraform-provisioner-ansible /root/.terraform.d/plugins/terraform-provisioner-ansible
ENTRYPOINT ["/bin/bash"]
