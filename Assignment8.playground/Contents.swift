import UIKit

class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String) {
        self.moduleName = moduleName
    }
    
    func assignDrone(drone: Drone) {
        self.drone = drone
    }
}

class ControlCenter: StationModule {
    private var isLockedDown: Bool = false
    private var securityCode: String
    
    init(securityCode: String, moduleName: String) {
        self.securityCode = securityCode
        super.init(moduleName: moduleName)
    }
    
    @discardableResult
    func lockdown(enteredCode: String) -> Bool {
        let isCorrectCode = enteredCode == securityCode
        isLockedDown = isCorrectCode
        return isCorrectCode
    }
    
    func printInfoAboutCC() {
        if isLockedDown {
            print("Control Center is now locked down.")
        } else {
            print("Incorrect passcode. Control Center is not locked down.")
        }
    }
}

class ResearchLab: StationModule {
    var researchModules: [String]
    
    override init(moduleName: String) {
        self.researchModules = []
        super.init(moduleName: moduleName)
    }
    
    func addResearchModule(_ module: String) {
        researchModules.append(module)
    }
}

class LifeSupportSystem: StationModule {
    private var oxygenLevel: Int
    
    init(oxygenLevel: Int, moduleName: String) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: moduleName)
    }
    
    func printInfoAboutOxygenLevel() {
        print("Oxygen Level is \(oxygenLevel)")
    }
}

class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    func checkTask() {
        if let task = task {
            print("Task is to \(task)")
        } else {
            print("No task assigned.")
        }
    }
}

class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    
    init() {
        controlCenter = ControlCenter(securityCode: "0000",
                                      moduleName: "Control Center")
        
        researchLab = ResearchLab(moduleName: "Research Lab")
        
        lifeSupportSystem = LifeSupportSystem(oxygenLevel: 95,
                                              moduleName: "Life Support System")
        
        let droneForControlCenter = Drone(assignedModule: controlCenter)
        let droneForResearchLab = Drone(assignedModule: researchLab)
        let droneForLifeSupportSystem = Drone(assignedModule: lifeSupportSystem)
    }
    
    @discardableResult
    func lockControlCenter(enteredCode: String) -> Bool {
        let isCorrectCode = controlCenter.lockdown(enteredCode: enteredCode)
        return isCorrectCode
    }
}

class MissionControl {
    var spaceStation: OrbitronSpaceStation?
    
    func connectTo(_ orbitron: OrbitronSpaceStation) {
        spaceStation = orbitron
    }
    
    func requestControlCenterStatus() {
        spaceStation?.controlCenter.printInfoAboutCC()
    }
    
    func requestOxygenStatus() {
        spaceStation?.lifeSupportSystem.printInfoAboutOxygenLevel()
    }
    
    func requestDroneStatus() {
        spaceStation?.controlCenter.drone?.checkTask()
        spaceStation?.researchLab.drone?.checkTask()
        spaceStation?.lifeSupportSystem.drone?.checkTask()
    }
}

let orbitron = OrbitronSpaceStation()
let missionControl = MissionControl()

missionControl.connectTo(orbitron)
missionControl.requestControlCenterStatus()
orbitron.lifeSupportSystem.printInfoAboutOxygenLevel()

orbitron.controlCenter.printInfoAboutCC()

orbitron.controlCenter.assignDrone(drone: Drone(assignedModule:orbitron.controlCenter))
orbitron.researchLab.assignDrone(drone: Drone(assignedModule: orbitron.researchLab))
orbitron.lifeSupportSystem.assignDrone(drone: Drone(assignedModule: orbitron.lifeSupportSystem))

orbitron.controlCenter.drone?.task = "Monitor Security Systems."
orbitron.researchLab.drone?.task = "Collect Samples for Lab."
orbitron.lifeSupportSystem.drone?.task = "Monitor Oxygen Levels."

missionControl.requestDroneStatus()

let isCodeCorrect = orbitron.lockControlCenter(enteredCode: "0000")
orbitron.controlCenter.printInfoAboutCC()
