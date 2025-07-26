#!/bin/bash

# Скрипт для создания проекта с Clean Architecture
# Создает 4-слойную архитектуру: Domain, Application, Infrastructure, WebAPI
# Настраивает правильные зависимости между слоями и конфигурационные файлы
# Использование: ./create-clean-architecture.sh <путь_к_родительской_папке> <имя_проекта>

# Проверяем количество аргументов
if [ $# -ne 2 ]; then
    echo "Использование: $0 <путь_к_родительской_папке> <имя_проекта>"
    echo "Пример: $0 /home/user/projects MyProject"
    exit 1
fi

# Получаем аргументы
PARENT_PATH=$1
PROJECT_NAME=$2

# Проверяем существование родительской папки
if [ ! -d "$PARENT_PATH" ]; then
    echo "Ошибка: Папка $PARENT_PATH не существует"
    exit 1
fi

# Создаем полный путь к проекту
PROJECT_PATH="$PARENT_PATH/$PROJECT_NAME"

# Проверяем, не существует ли уже папка проекта
if [ -d "$PROJECT_PATH" ]; then
    echo "Ошибка: Папка $PROJECT_PATH уже существует"
    exit 1
fi

echo "🚀 Создание Clean Architecture решения..."
echo "📁 Путь: $PROJECT_PATH"
echo "📋 Имя проекта: $PROJECT_NAME"
echo ""

# Создаем основную папку проекта
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# Создаем структуру папок
echo "📂 Создание структуры папок..."
mkdir src
mkdir tests

echo ""
echo "⚙️  Создание конфигурационных файлов..."

# Создаем .gitignore
echo "  🔧 Создание .gitignore..."
dotnet new gitignore

# Создаем .editorconfig
echo "  🔧 Создание .editorconfig..."
dotnet new editorconfig

# Создаем global.json для фиксации версии .NET SDK
echo "  🔧 Создание global.json..."
cat > global.json << 'EOF'
{
  "sdk": {
    "version": "8.0.412",
    "rollForward": "latestFeature"
  }
}
EOF

# Создаем Directory.Build.props для общих настроек всех проектов
echo "  🔧 Создание Directory.Build.props..."
cat > Directory.Build.props << 'EOF'
<Project>
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
EOF

# Создаем .gitattributes для правильной обработки файлов в Git
echo "  🔧 Создание .gitattributes..."
cat > .gitattributes << 'EOF'
# Auto detect text files and perform LF normalization
* text=auto

# C# files
*.cs text diff=csharp

# Visual Studio Solution files
*.sln text eol=crlf

# Visual Studio Project files
*.csproj text
*.vbproj text
*.vcxproj text
*.vcproj text
*.dbproj text
*.fsproj text

# JetBrains Rider files
*.DotSettings text

# XML project files
*.xml text
*.props text
*.targets text

# JSON files
*.json text

# Markdown files
*.md text

# Git files
.gitattributes text
.gitignore text

# Binary files
*.dll binary
*.exe binary
*.pdb binary
*.zip binary
*.7z binary
*.tar.gz binary

# JetBrains Rider cache and temp files
*.tmp binary
*.bak binary
EOF

echo ""
echo "📦 Создание решения и проектов..."

# Создаем файл решения
echo "  🔧 Создание решения $PROJECT_NAME.sln..."
dotnet new sln -n "$PROJECT_NAME"

# Создаем проекты Clean Architecture слоев
echo "  📋 Создание проектов Clean Architecture..."
echo "    - Создание Domain слоя (центральный слой с бизнес-логикой)..."
dotnet new classlib -n "$PROJECT_NAME.Domain" -o "src/$PROJECT_NAME.Domain"

echo "    - Создание Application слоя (use cases и интерфейсы)..."
dotnet new classlib -n "$PROJECT_NAME.Application" -o "src/$PROJECT_NAME.Application"

echo "    - Создание Infrastructure слоя (реализация внешних зависимостей)..."
dotnet new classlib -n "$PROJECT_NAME.Infrastructure" -o "src/$PROJECT_NAME.Infrastructure"

echo "    - Создание WebAPI слоя (точка входа приложения)..."
dotnet new webapi -n "$PROJECT_NAME.WebAPI" -o "src/$PROJECT_NAME.WebAPI"

# Создаем тестовые проекты
echo "  🧪 Создание тестовых проектов..."
echo "    - Создание UnitTests (тестирование Domain + Application)..."
dotnet new xunit -n "$PROJECT_NAME.UnitTests" -o "tests/$PROJECT_NAME.UnitTests"

echo "    - Создание IntegrationTests (тестирование Infrastructure + WebAPI)..."
dotnet new xunit -n "$PROJECT_NAME.IntegrationTests" -o "tests/$PROJECT_NAME.IntegrationTests"

echo ""
echo "🔗 Добавление проектов в решение..."

# Добавляем все проекты в .sln файл
dotnet sln add "src/$PROJECT_NAME.Domain/$PROJECT_NAME.Domain.csproj"
dotnet sln add "src/$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj"
dotnet sln add "src/$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj"
dotnet sln add "src/$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.csproj"
dotnet sln add "tests/$PROJECT_NAME.UnitTests/$PROJECT_NAME.UnitTests.csproj"
dotnet sln add "tests/$PROJECT_NAME.IntegrationTests/$PROJECT_NAME.IntegrationTests.csproj"

echo ""
echo "🔗 Настройка зависимостей Clean Architecture..."

# Настраиваем зависимости согласно принципам Clean Architecture
# Application зависит только от Domain
dotnet add "src/$PROJECT_NAME.Application" reference "src/$PROJECT_NAME.Domain"

# Infrastructure зависит от Application и Domain (реализует интерфейсы из Application)
dotnet add "src/$PROJECT_NAME.Infrastructure" reference "src/$PROJECT_NAME.Application"
dotnet add "src/$PROJECT_NAME.Infrastructure" reference "src/$PROJECT_NAME.Domain"

# WebAPI зависит только от Application (следует принципу инверсии зависимостей)
dotnet add "src/$PROJECT_NAME.WebAPI" reference "src/$PROJECT_NAME.Application"

# Настраиваем зависимости тестовых проектов
# UnitTests тестируют Domain и Application слои
dotnet add "tests/$PROJECT_NAME.UnitTests" reference "src/$PROJECT_NAME.Domain"
dotnet add "tests/$PROJECT_NAME.UnitTests" reference "src/$PROJECT_NAME.Application"

# IntegrationTests тестируют Infrastructure и WebAPI слои
dotnet add "tests/$PROJECT_NAME.IntegrationTests" reference "src/$PROJECT_NAME.Infrastructure"
dotnet add "tests/$PROJECT_NAME.IntegrationTests" reference "src/$PROJECT_NAME.WebAPI"

echo ""
echo "🧹 Очистка автоматически созданных файлов..."

# Удаляем автоматически созданные Class1.cs файлы
if [ -f "src/$PROJECT_NAME.Domain/Class1.cs" ]; then
    rm "src/$PROJECT_NAME.Domain/Class1.cs"
    echo "  ✓ Удален src/$PROJECT_NAME.Domain/Class1.cs"
fi

if [ -f "src/$PROJECT_NAME.Application/Class1.cs" ]; then
    rm "src/$PROJECT_NAME.Application/Class1.cs"
    echo "  ✓ Удален src/$PROJECT_NAME.Application/Class1.cs"
fi

if [ -f "src/$PROJECT_NAME.Infrastructure/Class1.cs" ]; then
    rm "src/$PROJECT_NAME.Infrastructure/Class1.cs"
    echo "  ✓ Удален src/$PROJECT_NAME.Infrastructure/Class1.cs"
fi

# Удаляем автоматически созданный .http файл
if [ -f "src/$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.http" ]; then
    rm "src/$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.http"
    echo "  ✓ Удален src/$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.http"
fi

# Упрощаем Program.cs до минимального содержимого
echo "  🔧 Упрощение Program.cs..."
PROGRAM_CS_PATH="src/$PROJECT_NAME.WebAPI/Program.cs"
if [ -f "$PROGRAM_CS_PATH" ]; then
    cat > "$PROGRAM_CS_PATH" << 'EOF'
var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

app.Run();
EOF
    echo "  ✓ Обновлен src/$PROJECT_NAME.WebAPI/Program.cs"
fi

# Удаляем автоматически созданные UnitTest1.cs файлы
if [ -f "tests/$PROJECT_NAME.UnitTests/UnitTest1.cs" ]; then
    rm "tests/$PROJECT_NAME.UnitTests/UnitTest1.cs"
    echo "  ✓ Удален tests/$PROJECT_NAME.UnitTests/UnitTest1.cs"
fi

if [ -f "tests/$PROJECT_NAME.IntegrationTests/UnitTest1.cs" ]; then
    rm "tests/$PROJECT_NAME.IntegrationTests/UnitTest1.cs"
    echo "  ✓ Удален tests/$PROJECT_NAME.IntegrationTests/UnitTest1.cs"
fi

echo ""
echo "🏗️  Проверка сборки проекта..."

# Финальная проверка - собираем проект
if dotnet build > /dev/null 2>&1; then
    echo ""
    echo "✅ Clean Architecture решение успешно создано!"
    echo "📁 Расположение: $PROJECT_PATH"
    echo ""
    echo "📋 Структура проекта:"
    echo "$PROJECT_NAME/"
    echo "├── $PROJECT_NAME.sln"
    echo "├── Directory.Build.props"
    echo "├── global.json"
    echo "├── .gitignore"
    echo "├── .editorconfig"
    echo "├── .gitattributes"
    echo "├── src/"
    echo "│   ├── $PROJECT_NAME.Domain/           # Бизнес-логика, сущности"
    echo "│   ├── $PROJECT_NAME.Application/      # Use cases, интерфейсы"
    echo "│   ├── $PROJECT_NAME.Infrastructure/   # Внешние зависимости"
    echo "│   └── $PROJECT_NAME.WebAPI/           # API endpoints"
    echo "└── tests/"
    echo "    ├── $PROJECT_NAME.UnitTests/        # Тесты Domain + Application"
    echo "    └── $PROJECT_NAME.IntegrationTests/ # Тесты Infrastructure + WebAPI"
    echo ""
    echo "🎯 Зависимости Clean Architecture:"
    echo "Domain ← Application ← Infrastructure"
    echo "       ← Application ← WebAPI"
    echo ""
    echo "🚀 Для начала работы выполните:"
    echo "cd $PROJECT_PATH"
    echo "dotnet run --project src/$PROJECT_NAME.WebAPI"
    echo ""
    echo "🧪 Для запуска тестов:"
    echo "dotnet test"
else
    echo "❌ Ошибка при сборке проекта"
    echo "Запустите 'dotnet build' для просмотра ошибок"
    exit 1
fi