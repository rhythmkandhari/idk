#include <iostream>
#include <algorithm>
using namespace std;

struct Process {
    int pid;            
    int burstTime;      
    int priority;      
    int waitingTime;    
    int turnaroundTime;
};


bool compareByPriority(Process a, Process b) {
    return a.priority < b.priority;
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
        cout << "Enter priority for Process " << p[i].pid << " (lower number = higher priority): ";
        cin >> p[i].priority;
    }


    sort(p, p + n, compareByPriority);

 
    p[0].waitingTime = 0;
    for (int i = 1; i < n; i++) {
        p[i].waitingTime = p[i - 1].waitingTime + p[i - 1].burstTime;
    }

   
    for (int i = 0; i < n; i++) {
        p[i].turnaroundTime = p[i].waitingTime + p[i].burstTime;
    }

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
