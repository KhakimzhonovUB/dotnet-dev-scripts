# Clean Architecture Scripts

Скрипт для автоматического создания и настройки .NET проектов на основе принципов Clean Architecture

## 📁 Содержимое

| Скрипт | Описание |
|--------|----------|
| `create-clean-architecture.sh` | Создает полный проект с 4-слойной Clean Architecture |

## 🏗️ Clean Architecture

Скрипт создает следующую архитектуру:

```
ProjectName/
├── src/
│   ├── ProjectName.Domain/          # 🎯 Центральный слой (бизнес-логика)
│   ├── ProjectName.Application/     # 📋 Use cases и интерфейсы
│   ├── ProjectName.Infrastructure/  # 🔧 Внешние зависимости (БД, API)
│   └── ProjectName.WebAPI/          # 🌐 Точка входа (Controllers)
└── tests/
    ├── ProjectName.UnitTests/       # ✅ Тесты Domain + Application
    └── ProjectName.IntegrationTests/ # 🔗 Тесты Infrastructure + WebAPI
```

### 🎯 Принципы зависимостей

```
Domain (центр, без зависимостей)
   ↑
Application (зависит только от Domain)
   ↑                    ↑
Infrastructure      WebAPI
```

- **Domain** - не зависит ни от кого
- **Application** - зависит только от Domain
- **Infrastructure** - реализует интерфейсы из Application
- **WebAPI** - зависит только от Application (инверсия зависимостей)

## 🚀 Использование

### create-clean-architecture.sh

Создает новый проект с полной Clean Architecture структурой и автоматически очищает лишние файлы

```bash
# Синтаксис
./create-clean-architecture.sh <путь_к_родительской_папке> <имя_проекта>

# Примеры
./create-clean-architecture.sh . MyECommerceApp
./create-clean-architecture.sh ~/Projects BlogSystem
./create-clean-architecture.sh /home/user/dev InventoryManagement
```

**Что создает:**
- ✅ 4 основных проекта Clean Architecture
- ✅ 2 тестовых проекта (Unit + Integration)
- ✅ Все конфигурационные файлы (.gitignore, .editorconfig, global.json, Directory.Build.props, .gitattributes)
- ✅ Правильные зависимости между слоями
- ✅ Автоматическая очистка от лишних файлов (Class1.cs, UnitTest1.cs, .http файлы)
- ✅ Упрощенный Program.cs

## ⚙️ Требования

- **Git Bash** (для Windows) или любой bash-совместимый терминал
- **.NET 8 SDK** (версия 8.0.412 или новее)
- **Права на создание файлов** в указанной папке

## 📋 Проверка требований

```bash
# Проверить версию .NET
dotnet --version

# Проверить доступность команд dotnet
dotnet --list-sdks

# Сделать скрипт исполняемым (если нужно)
chmod +x create-clean-architecture.sh
```

## 🎛️ Созданные конфигурации

### Конфигурационные файлы

| Файл | Назначение |
|------|------------|
| `.gitignore` | Исключения для Git (через `dotnet new gitignore`) |
| `.editorconfig` | Настройки форматирования кода |
| `global.json` | Фиксация версии .NET SDK (8.0.412) |
| `Directory.Build.props` | Общие настройки MSBuild для всех проектов |
| `.gitattributes` | Настройки Git для обработки файлов (поддержка Rider) |

### Directory.Build.props

```xml
<Project>
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
```

## 📊 Примеры проектов

### Blog API
```bash
./create-clean-architecture.sh . BlogAPI
cd BlogAPI
dotnet build
```

### E-Commerce микросервис
```bash
./create-clean-architecture.sh ~/Projects ECommerce.OrderService
cd ~/Projects/ECommerce.OrderService
dotnet run --project src/ECommerce.OrderService.WebAPI
```

### Система управления пользователями
```bash
./create-clean-architecture.sh /c/Development UserManagement
cd /c/Development/UserManagement
dotnet test
```

## 🛠️ Устранение неполадок

### Ошибка "Permission denied"
```bash
chmod +x create-clean-architecture.sh
```

### Ошибка "dotnet command not found"
Убедитесь, что .NET 8 SDK установлен:
- Скачайте с [официального сайта](https://dotnet.microsoft.com/download/dotnet/8.0)
- Перезапустите терминал после установки

### Ошибка сборки проекта
```bash
# Проверьте версию .NET
dotnet --version

# Попробуйте восстановить пакеты
dotnet restore

# Подробная диагностика
dotnet build --verbosity detailed
```

### Проект уже существует
```bash
# Удалите существующую папку или выберите другое имя
rm -rf ExistingProject
./create-clean-architecture.sh . NewProjectName
```

## 🔄 Рабочий процесс

### Создание нового проекта
1. **Создание структуры**: `./create-clean-architecture.sh . MyProject`
2. **Переход в проект**: `cd MyProject`
3. **Проверка сборки**: `dotnet build`
4. **Запуск API**: `dotnet run --project src/MyProject.WebAPI`
5. **Запуск тестов**: `dotnet test`

## 📚 Дополнительные ресурсы

- [Clean Architecture by Robert Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [.NET Application Architecture Guides](https://dotnet.microsoft.com/learn/dotnet/architecture-guides)
- [Microsoft Clean Architecture Template](https://github.com/jasontaylordev/CleanArchitecture)

## 🤝 Поддержка

При возникновении проблем:
1. Проверьте версию .NET SDK: `dotnet --version`
2. Убедитесь в правах на создание файлов
3. Проверьте синтаксис команды
4. При ошибках сборки выполните `dotnet build` для детальной диагностики