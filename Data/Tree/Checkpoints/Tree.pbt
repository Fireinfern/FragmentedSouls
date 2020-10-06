Name: "Checkpoints"
RootId: 13157162591483068476
Objects {
  Id: 3218341182723338586
  Name: "Checkpoint1"
  Transform {
    Location {
      X: 4600
      Y: -7150
      Z: 800
    }
    Rotation {
    }
    Scale {
      X: 7.5
      Y: 1
      Z: 7.24999809
    }
  }
  ParentId: 13157162591483068476
  ChildIds: 15830483019034561638
  WantsNetworking: true
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
}
Objects {
  Id: 15830483019034561638
  Name: "Checkpoint"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 0.13333334
      Y: 1
      Z: 0.137931064
    }
  }
  ParentId: 3218341182723338586
  UnregisteredParameters {
    Overrides {
      Name: "cs:CheckpointNumber"
      Int: 1
    }
  }
  WantsNetworking: true
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 5566299157831063603
    }
  }
}
