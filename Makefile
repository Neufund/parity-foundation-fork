help:
	@echo "container - builds parity container"
	@echo "run - runs node"
	@echo "down - bring node down"

container:
	docker build . -t neufund/parity-foundation-fork

run: container
	docker-compose -p eth_parity_foundation_fork -f docker-compose.yml up --build -d

container-rust:
	docker build . -f Dockerfile.rust -t neufund/parity-foundation-fork-rust

run-rust: container-rust
	docker-compose -p eth_parity_foundation_fork -f docker-compose-rust.yml up -d

down:
	docker-compose -p eth_parity_foundation_fork -f docker-compose.yml down
