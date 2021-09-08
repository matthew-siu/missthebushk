//
//  StopReminderManager.swift
//  missthebus
//
//  Created by Matthew Siu on 29/7/2021.
//

import Foundation

// basic: CRUD

class StopReminderManager {
    
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
            reminders.insert(reminder, at: 0)
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
    
    static func rearrangeStopReminder(at pos1: Int, to pos2: Int){
        if var reminders = self.getStopReminders(){
            let mover = reminders.remove(at: pos1)
            reminders.insert(mover, at: pos2)
            self.saveStopReminders(reminders)
        }
    }
    
    static func getUpcomingStopReminder() -> StopReminder?{
        var upcomingReminder: StopReminder? = nil
        let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
        let nowDate = Date() // save date, so all components use the same date
        var maxMinutes = 31
        if let reminders = self.getStopReminders(){
            let todayReminders = reminders.filter({$0.isToday})
            for reminder in todayReminders{
                var dateComponents = DateComponents()
                dateComponents.year = calendar.component(.year, from: nowDate)
                dateComponents.month = calendar.component(.month, from: nowDate)
                dateComponents.day = calendar.component(.day, from: nowDate)
                dateComponents.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "")
                dateComponents.hour = calendar.component(.hour, from: reminder.startTime)
                dateComponents.minute = calendar.component(.minute, from: reminder.startTime)
                if let reminderDateTime = calendar.date(from: dateComponents){
                    let diff = Calendar.current.dateComponents([.minute], from: reminderDateTime, to: nowDate)
                    if let diffMin = diff.minute{
                        Log.d(.RUNTIME, "\(reminder.name ?? "") diff = \(diffMin)")
                        if (diffMin >= 0 && diffMin < maxMinutes){
                            Log.d(.RUNTIME, "Closest reminder is \(reminder.name ?? "")")
                            maxMinutes = diffMin
                            upcomingReminder = reminder
                            if (maxMinutes == 0){
                                return upcomingReminder
                            }
                        }
                    }
                }
            }
        }
        return upcomingReminder
    }
}
