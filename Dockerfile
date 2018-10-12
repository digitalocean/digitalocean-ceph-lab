# Copyright 2018 DigitalOcean
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM hashicorp/terraform:light
RUN apk update && apk add ansible bash
ADD https://github.com/radekg/terraform-provisioner-ansible/releases/download/v2.0.1/terraform-provisioner-ansible-linux-amd64_v2.0.1 /root/.terraform.d/plugins/terraform-provisioner-ansible
RUN chmod 755 /root/.terraform.d/plugins/terraform-provisioner-ansible
ENTRYPOINT ["/bin/bash"]
