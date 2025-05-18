#include <iostream>
using namespace std;

int main() {
    int n;
    cout << "Enter number of processes: ";
    cin >> n;

    int arrival[n], burst[n], remaining[n];
    int complete = 0, time = 0, shortest = -1, minRemaining = 1e9;
    bool found = false;
    int waiting[n], turnaround[n], completion[n];

    for (int i = 0; i < n; i++) {
        cout << "Enter Arrival Time and Burst Time for Process " << i + 1 << ": ";
        cin >> arrival[i] >> burst[i];
        remaining[i] = burst[i];
        waiting[i] = turnaround[i] = completion[i] = 0;
    }

    while (complete != n) {
        shortest = -1;
        minRemaining = 1e9;

        for (int i = 0; i < n; i++) {
            if (arrival[i] <= time && remaining[i] > 0 && remaining[i] < minRemaining) {
                minRemaining = remaining[i];
                shortest = i;
                found = true;
            }
        }

        if (shortest == -1) {
            time++;
            continue;
        }

        remaining[shortest]--;

        if (remaining[shortest] == 0) {
            complete++;
            completion[shortest] = time + 1;
            turnaround[shortest] = completion[shortest] - arrival[shortest];
            waiting[shortest] = turnaround[shortest] - burst[shortest];
        }

        time++;
    }

    float totalWT = 0, totalTAT = 0;
    cout << "\nPID\tAT\tBT\tCT\tTAT\tWT\n";
    for (int i = 0; i < n; i++) {
        cout << i + 1 << "\t" << arrival[i] << "\t" << burst[i] << "\t" << completion[i]
             << "\t" << turnaround[i] << "\t" << waiting[i] << endl;
        totalWT += waiting[i];
        totalTAT += turnaround[i];
    }

    cout << "\nAverage Waiting Time: " << totalWT / n;
    cout << "\nAverage Turnaround Time: " << totalTAT / n << endl;

    return 0;
}
