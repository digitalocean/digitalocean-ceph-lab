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

check: shellcheck ansible-lint terraform-validate
.PHONY: check

shellcheck:
	find . -name '*.sh' \
		-exec docker run -it --rm \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		koalaman/shellcheck:stable {} \
		\;
.PHONY: shellcheck

ansible-lint:
	docker run -it --rm \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		particlekit/ansible-lint:latest \
		ansible-lint ./ansible/*.yml
.PHONY: ansible-lint

terraform-validate:
	docker build -t terraform-ansible:latest .
	docker run -it --rm \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		--entrypoint /bin/terraform \
		terraform-ansible:latest \
		init
	docker run -it --rm \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		--entrypoint /bin/terraform \
		terraform-ansible:latest \
		validate \
		-var do_token='dummy' \
		-var lab_name='dummy' \
		-var region='dummy' \
		-var ssh_pub_key='dummy' \
		-var ssh_priv_key='dummy'
.PHONY: terraform-validate
