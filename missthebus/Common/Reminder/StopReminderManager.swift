//
//  StopReminderManager.swift
//  missthebus
//
//  Created by Matthew Siu on 29/7/2021.
//

import Foundation
import SQLite3

// search methods

class StopReminderManager{
    
    // get reminder of kmb
    static func getRemindersFromRoute(route: String, bound: String, serviceType: String) -> [StopReminder]?{
        return self.getStopReminders()?.filter({$0.route == route && $0.bound == bound && $0.serviceType == serviceType})
        
    }
}

// basic: CRUD

extension StopReminderManager {
    
    static func getStopReminders() -> [StopReminder]?{
        if let data = Storage.getObject(Configs.Storage.KEY_REMINDERS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([StopReminder].self, from: data)
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
    
    static func saveStopReminders(_ reminders: [StopReminder]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            Storage.save(Configs.Storage.KEY_REMINDERS, data)
        } catch {
            print("StopReminders: Unable to Encode Note (\(error))")
        }
    }
    
    static func addStopReminder(_ reminder: StopReminder){
        self.removeStopReminder(reminder.id) // remove reminderId
        if var reminders = self.getStopReminders(){
            reminders.append(reminder)
            self.saveStopReminders(reminders)
        }else{
            self.saveStopReminders([reminder])
        }
    }
    
    static func removeStopReminder(_ reminderId: String){
        if var reminders = self.getStopReminders(){
            reminders.removeAll(where: {$0.id == reminderId})
            self.saveStopReminders(reminders)
        }
    }
    
    static func updateStopReminder(_ reminder: StopReminder){
        self.removeStopReminder(reminder.id)
        self.addStopReminder(reminder)
    }
}
