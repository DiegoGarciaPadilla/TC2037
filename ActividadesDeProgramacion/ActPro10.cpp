#include <iostream>
#include <cmath>
#include <pthread.h>

void* calcularRaizCuadrada(void*) {
    for (int i = 1; i <= 10; i++) {
        double raiz = std::sqrt(i);
        std::cout << "Raiz cuadrada de " << i << ": " << raiz << std::endl;
    }
    return nullptr;
}

void* calcularCuadrado(void*) {
    for (int i = 1; i <= 10; i++) {
        int cuadrado = i * i;
        std::cout << "Cuadrado de " << i << ": " << cuadrado << std::endl;
    }
    return nullptr;
}

int main() {
    pthread_t t1, t2;

    pthread_create(&t1, nullptr, calcularRaizCuadrada, nullptr);
    pthread_join(t1, nullptr);
    
    pthread_create(&t2, nullptr, calcularCuadrado, nullptr);
    pthread_join(t2, nullptr);

    return 0;
}