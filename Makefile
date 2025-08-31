.PHONY: help install ansible chezmoi clean test

# Default target
help:
	@echo "Available targets:"
	@echo "  install     - Install Ansible and run configuration"
	@echo "  ansible     - Install Ansible only"
	@echo "  chezmoi     - Apply dotfiles with Chezmoi"
	@echo "  test        - Test Ansible playbooks"
	@echo "  clean       - Clean up temporary files"
	@echo "  help        - Show this help message"

# Install Ansible and run configuration
install: ansible
	@echo "Running Ansible configuration..."
	ansible-playbook ansible/playbooks/main.yml

# Install Ansible
ansible:
	@echo "Installing Ansible..."
	@if ! command -v ansible &> /dev/null; then \
		chmod +x ansible/install-ansible.sh; \
		./ansible/install-ansible.sh; \
		ansible-galaxy collection install -r ansible/requirements.yml; \
	else \
		echo "Ansible is already installed"; \
	fi

# Apply dotfiles with Chezmoi
chezmoi:
	@echo "Applying dotfiles with Chezmoi..."
	chezmoi apply

# Test Ansible playbooks
test:
	@echo "Testing Ansible playbooks..."
	ansible-playbook ansible/playbooks/main.yml --check

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	find . -name "*.tmp" -delete
	find . -name "*.bak" -delete
	find . -name "*~" -delete

# Show project status
status:
	@echo "=== Project Status ==="
	@echo "Chezmoi status:"
	@chezmoi status || echo "Chezmoi not available"
	@echo ""
	@echo "Ansible version:"
	@ansible --version || echo "Ansible not available"
	@echo ""
	@echo "System information:"
	@uname -s -m -r
