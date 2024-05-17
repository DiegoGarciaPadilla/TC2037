#include <iostream>
#include <iomanip>
#include <chrono>
#include <pthread.h>

#include "utils.h"

using namespace std;
using namespace std::chrono;

#define THREADS 11
const int SIZE = 1000000000; // 1e9

typedef struct {
    int start, end, *C, *A, *B;
} Block;

void* add_vector(void* param) {
    Block *b = (Block*) param;
    for (int i = b->start; i < b->end; i++) {
        b->C[i] = b->A[i] + b->B[i];
    }

    return 0;
}

int main(int argc, char* argv[]) {
    int *A, *B, *C;
    pthread_t tids[THREADS];
    Block blocks[THREADS];
    int blockSize = SIZE / THREADS;

    // These variable are used to keep track of the execution time
    high_resolution_clock::time_point start, end;
    double timeElapsed;

    A = new int[SIZE];
    B = new int[SIZE];
    C = new int[SIZE];

    fill_array(A, SIZE);
    display_array("A:", A);
    fill_array(B, SIZE);
    display_array("B:", B);

    for(int i = 0; i < THREADS; i++){
        blocks[i].C = C;
        blocks[i].A = A;
        blocks[i].B = B;
        blocks[i].start = (i * blockSize);
        blocks[i].end = (i != (THREADS-1))? (i + 1) * blockSize : SIZE;

    }

    cout << "Starting...\n";
    timeElapsed = 0;
    for (int j = 0; j < N; j++) {
        start = high_resolution_clock::now();

        for(int i = 0; i < THREADS; i++){
            pthread_create(&tids[i], NULL, add_vector, &blocks[i]);
        }
        
        for(int i = 0; i < THREADS; i++){
            pthread_join(tids[i], NULL);
        }

        end = high_resolution_clock::now();

        timeElapsed += duration<double, std::milli>(end - start).count();
    }
    display_array("C:", C);
    cout << "avg time = " << fixed << setprecision(3) << (timeElapsed/N) << " ms\n";

    delete [] A;
    delete [] B;
    delete [] C;

    return 0;
}