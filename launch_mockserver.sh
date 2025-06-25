#!/bin/bash

# === CONFIGURATION ===
JAR_NAME="mockserver.jar"
JAR_PATH="./$JAR_NAME"
STUB_DIR="./TestStubs"
PORT=1080
JAVA_CMD=$(which java)

# === CHECKS ===
if [ ! -f "$JAR_PATH" ]; then
  echo "❌ Erreur : $JAR_NAME introuvable dans le répertoire courant."
  echo "Télécharge-le depuis :"
  echo "👉 https://repo1.maven.org/maven2/org/mock-server/mockserver-netty/5.15.0/"
  exit 1
fi

if [ ! -x "$JAVA_CMD" ]; then
  echo "❌ Java n'est pas installé ou non disponible dans le PATH."
  exit 1
fi

# === LANCEMENT MOCKSERVER ===
echo "🚀 Lancement de MockServer sur le port $PORT..."
java -jar "$JAR_PATH" -serverPort $PORT > mockserver.log 2>&1 & disown

# Attendre que MockServer soit prêt
sleep 2

# === CHARGEMENT DES STUBS ===
echo "📦 Chargement des expectations depuis $STUB_DIR"

for stub in "$STUB_DIR"/*.json; do
  echo "→ Envoi de $stub"
  curl -s -X PUT "http://localhost:$PORT/mockserver/expectation" \
    -H "Content-Type: application/json" \
    -d @"$stub" > /dev/null
done

echo "✅ Tous les stubs ont été chargés !"
