//  WorkoutStore.swift
import HealthKit
import WorkoutKit

struct WorkoutStore {
    static func createYogaCustomWorkout() -> CustomWorkout {
        let warmupStep = WorkoutStep()  // Warmup step
        let block1 = Self.yogaBlockOne()
        let block2 = Self.yogaBlockTwo()
        let cooldownStep = WorkoutStep(goal: .time(5, .minutes))
        
        return CustomWorkout(activity: .yoga,
                             location: .indoor,
                             displayName: "My Yoga Workout Kit",
                             warmup: warmupStep,
                             blocks: [block1, block2],
                             cooldown: cooldownStep)
    }
    
    static func yogaBlockOne() -> IntervalBlock {
        // Work step 1
        var workStep1 = IntervalStep(.work)
        workStep1.step.goal = .time(5, .minutes)
        workStep1.step.alert = .none
        
        var recoveryStep1 = IntervalStep(.recovery)
        recoveryStep1.step.goal = .time(5, .minutes)
        recoveryStep1.step.alert = .none
        
        return IntervalBlock(steps: [workStep1, recoveryStep1],
                             iterations: 4)
    }
    
    static func yogaBlockTwo() -> IntervalBlock {
        //Work step
        var workStep2 = IntervalStep(.work)
        workStep2.step.goal = .open
        workStep2.step.alert = .none
        
        //Recovery step.
        var recoveryStep2 = IntervalStep(.recovery)
        recoveryStep2.step.goal = .time(30, .seconds)
        recoveryStep2.step.alert = .heartRate(zone: 1)
        
        //Block with two iterations
        return IntervalBlock(steps: [workStep2, recoveryStep2],
                             iterations: 2)
    }
}

/*
static func createYogaWorkout() -> SingleGoalWorkout {
    SingleGoalWorkout(activity: .yoga,
                      goal: .time(45, .minutes))
}
*/
