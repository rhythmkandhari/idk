#include <iostream>
#include <algorithm>
using namespace std;

// Structure to represent a process
struct Process {
    int pid;            // Process ID
    int burstTime;      // CPU Burst Time
    int priority;       // Priority (lower value = higher priority)
    int waitingTime;    // Waiting Time
    int turnaroundTime; // Turnaround Time
};

// Compare function to sort processes by priority
bool compareByPriority(Process a, Process b) {
    return a.priority < b.priority;
}
int main() {
    int n;
    cout << "Enter number of processes: ";
    cin >> n;

    Process p[n];

    // Taking input for burst time and priority
    for (int i = 0; i < n; i++) {
        p[i].pid = i + 1; // Assign process ID
        cout << "Enter burst time for Process " << p[i].pid << ": ";
        cin >> p[i].burstTime;
        cout << "Enter priority for Process " << p[i].pid << " (lower number = higher priority): ";
        cin >> p[i].priority;
    }

    // Sort the processes based on priority
    sort(p, p + n, compareByPriority);

    // Calculate waiting time
    p[0].waitingTime = 0;
    for (int i = 1; i < n; i++) {
        p[i].waitingTime = p[i - 1].waitingTime + p[i - 1].burstTime;
    }

    // Calculate turnaround time
    for (int i = 0; i < n; i++) {
        p[i].turnaroundTime = p[i].waitingTime + p[i].burstTime;
    }

    // Display results
    float avgWT = 0, avgTAT = 0;
    cout << "\nProcess\tBurst\tPriority\tWaiting\tTurnaround\n";
    for (int i = 0; i < n; i++) {
        cout << "P" << p[i].pid << "\t" << p[i].burstTime << "\t" << p[i].priority << "\t\t"
             << p[i].waitingTime << "\t" << p[i].turnaroundTime << "\n";
        avgWT += p[i].waitingTime;
        avgTAT += p[i].turnaroundTime;
    }

    cout << "\nAverage Waiting Time: " << avgWT / n;
    cout << " ms\nAverage Turnaround Time: " << avgTAT / n << " ms\n";

    return 0;
}
