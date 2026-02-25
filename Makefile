PROTOC = protoc
PROTO_DIR = ./pingpong
OUT_DIR = ./gen/go
PROTO_FILES = $(shell find $(PROTO_DIR) -name "*.proto")

# Команда по умолчанию
.PHONY: all
all: regen

# Генерация Go-кода
.PHONY: gen
gen:
	mkdir -p $(OUT_DIR)
	$(PROTOC) -I ./ $(PROTO_FILES) \
		--go_out=$(OUT_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative
	@echo "✅ Proto files compiled successfully!"
	$(MAKE) docs

# Очистка сгенерированных файлов
.PHONY: clean
clean:
	rm -rf $(OUT_DIR)
	@echo "✅ Cleaned up."

# Сгенерировать заново
.PHONY: regen
regen:
	$(MAKE) clean
	$(MAKE) gen

# Установка необходимых плагинов (если не установлены)
.PHONY: install
install:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@latest
	@echo "✅ Installed protoc-gen-go."

# Сгенерировать документацию:
.PHONY: docs
docs:
	$(PROTOC) --doc_out=. --doc_opt=docs/template.tmpl,API.md $(PROTO_FILES)
	@echo "✅ Документация создана в API.md"

.PHONY: tidy
tidy:
	@echo "Обновление зависимостей"
	go mod tidy