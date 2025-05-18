#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct Process {
    int pid;
    int arrivalTime;
    int burstTime;
    int remainingTime;
    int priority;
    int waitingTime;
    int turnaroundTime;
    bool isCompleted;
};

int main() {
    int n;
    cout << "Enter the number of processes: ";
    cin >> n;

    vector<Process> p(n);

    for (int i = 0; i < n; i++) {
        p[i].pid = i + 1;
        cout << "Enter Arrival Time, Burst Time and Priority for Process P" << p[i].pid << ":\n";
        cin >> p[i].arrivalTime >> p[i].burstTime >> p[i].priority;
        p[i].remainingTime = p[i].burstTime;
        p[i].isCompleted = false;
    }

    int time = 0, completed = 0;
    float totalWT = 0, totalTAT = 0;

    while (completed < n) {
        int idx = -1;
        int highestPriority = 9999;

        for (int i = 0; i < n; i++) {
            if (p[i].arrivalTime <= time && !p[i].isCompleted && p[i].remainingTime > 0) {
                if (p[i].priority < highestPriority) {
                    highestPriority = p[i].priority;
                    idx = i;
                }
            }
        }

        if (idx != -1) {
            p[idx].remainingTime--;

            // Completion
            if (p[idx].remainingTime == 0) {
                completed++;
                int finishTime = time + 1;
                p[idx].turnaroundTime = finishTime - p[idx].arrivalTime;
                p[idx].waitingTime = p[idx].turnaroundTime - p[idx].burstTime;
                totalWT += p[idx].waitingTime;
                totalTAT += p[idx].turnaroundTime;
                p[idx].isCompleted = true;
            }
        }

        time++;
    }

    // Output
    cout << "\nProcess\tArrival\tBurst\tPriority\tWaiting\tTurnaround\n";
    for (int i = 0; i < n; i++) {
        cout << "P" << p[i].pid << "\t" << p[i].arrivalTime << "\t" << p[i].burstTime << "\t" 
             << p[i].priority << "\t\t" << p[i].waitingTime << "\t" << p[i].turnaroundTime << "\n";
    }

    cout << "Average Waiting Time: " << totalWT / n << "\n";
    cout << "Average Turnaround Time: " << totalTAT / n << "\n";

    return 0;
}
