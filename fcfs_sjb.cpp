#include <iostream>
#include <algorithm>
using namespace std;

struct Process {
    int pid;
    int burstTime;
    int waitingTime;
    int turnaroundTime;
};

// // Compare function to sort processes by burst time
bool compare(Process a, Process b) {
    return a.burstTime < b.burstTime;
}

int main() {
    int n;
    cout << "Enter number of processes: ";
    cin >> n;

    Process p[n];

    for (int i = 0; i < n; i++) {
        p[i].pid = i + 1;
        cout << "Enter burst time for Process " << p[i].pid << ": ";
        cin >> p[i].burstTime;
    }

    // Sort by burst time
   sort(p, p + n, compare);

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
    cout << "\nProcess\tBurst\tWaiting\tTurnaround\n";
    for (int i = 0; i < n; i++) {
        cout << "P" << p[i].pid << "\t" << p[i].burstTime << "\t" << p[i].waitingTime
             << "\t" << p[i].turnaroundTime << "\n";
        avgWT += p[i].waitingTime;
        avgTAT += p[i].turnaroundTime;
    }

    cout << "\nAverage Waiting Time: " << avgWT / n;
    cout << "\nAverage Turnaround Time: " << avgTAT / n;

    return 0;
}