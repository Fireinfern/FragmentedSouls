Assets {
  Id: 16290562855614850046
  Name: "ArrowTrapAutomatic"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 2303106816200482418
      Objects {
        Id: 2303106816200482418
        Name: "ArrowTrap"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 10384891091842511792
        ChildIds: 4773487141424315949
        ChildIds: 10712076960726413682
        ChildIds: 9799352685135220876
        ChildIds: 1850854982466281452
        ChildIds: 3455562713695336305
        ChildIds: 12025174899449725934
        ChildIds: 1348435041801658242
        ChildIds: 4061064452304388728
        ChildIds: 17396630222178160669
        ChildIds: 12215109131940877006
        ChildIds: 18340645352516477508
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 10384891091842511792
        Name: "ShootDart"
        Transform {
          Location {
            X: -650
            Y: -268.37738
            Z: -200.530853
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
          }
          Overrides {
            Name: "cs:WaitTime"
            Float: 1.5
          }
          Overrides {
            Name: "cs:ShootTime"
            Float: 0.25
          }
          Overrides {
            Name: "cs:TriggerHit"
            ObjectReference {
              SubObjectId: 10712076960726413682
            }
          }
          Overrides {
            Name: "cs:Arrow"
            AssetReference {
              Id: 16724655384854313535
            }
          }
          Overrides {
            Name: "cs:ShootSound"
            ObjectReference {
              SubObjectId: 9799352685135220876
            }
          }
          Overrides {
            Name: "cs:ArrowTrigger"
            ObjectReference {
              SubObjectId: 10712076960726413682
            }
          }
          Overrides {
            Name: "cs:ArrowPos"
            ObjectReference {
              SubObjectId: 3455562713695336305
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos"
            ObjectReference {
              SubObjectId: 12025174899449725934
            }
          }
          Overrides {
            Name: "cs:ArrowPos2"
            ObjectReference {
              SubObjectId: 1348435041801658242
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos2"
            ObjectReference {
              SubObjectId: 4061064452304388728
            }
          }
          Overrides {
            Name: "cs:ArrowPos3"
            ObjectReference {
              SubObjectId: 17396630222178160669
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos3"
            ObjectReference {
              SubObjectId: 12215109131940877006
            }
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
            Id: 5338426075553187906
          }
        }
      }
      Objects {
        Id: 4773487141424315949
        Name: "ArrowDamage"
        Transform {
          Location {
            X: -650
            Y: -268.37738
            Z: -200.530853
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "cs:ShootDart"
            ObjectReference {
              SubObjectId: 10384891091842511792
            }
          }
          Overrides {
            Name: "cs:TriggerHit"
            ObjectReference {
              SubObjectId: 10712076960726413682
            }
          }
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
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
            Id: 15066764829990571874
          }
        }
      }
      Objects {
        Id: 10712076960726413682
        Name: "TriggerHit"
        Transform {
          Location {
            Y: -390.312317
            Z: 140.23349
          }
          Rotation {
          }
          Scale {
            X: 0.635209739
            Y: 2.91840839
            Z: 3.51904464
          }
        }
        ParentId: 2303106816200482418
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceon"
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
        Id: 9799352685135220876
        Name: "Recurve Bow Fire Release Arrow Heavy 01 SFX"
        Transform {
          Location {
            Y: -250
            Z: 100
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        AudioInstance {
          AudioAsset {
            Id: 15870650808192187890
          }
          Volume: 1
          Falloff: -1
          Radius: -1
          EnableOcclusion: true
          IsSpatializationEnabled: true
          IsAttenuationEnabled: true
        }
      }
      Objects {
        Id: 1850854982466281452
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            Y: -292.719482
            Z: -61.0137634
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 3.82339787
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14470038530306782275
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 3455562713695336305
        Name: "ArrowPos"
        Transform {
          Location {
            Y: -300
            Z: -1.73182678
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        ChildIds: 4703956641043764185
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 4703956641043764185
        Name: "ArrowHole"
        Transform {
          Location {
            X: 0.175048828
            Y: 50
            Z: -15.1619415
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 3455562713695336305
        ChildIds: 14608160800332420966
        ChildIds: 12362674211683594625
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 14608160800332420966
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            X: -0.174987793
            Y: -3.58477783
          }
          Rotation {
          }
          Scale {
            X: 0.314033568
            Y: 0.438337445
            Z: 0.281833619
          }
        }
        ParentId: 4703956641043764185
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14492599398820280602
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 12362674211683594625
        Name: "Pipe - 4-Sided Thick"
        Transform {
          Location {
            X: 0.174987793
            Y: 3.58477783
            Z: 12.6639557
          }
          Rotation {
            Roll: 89.9999084
          }
          Scale {
            X: 0.376865923
            Y: 0.376865923
            Z: 0.184485152
          }
        }
        ParentId: 4703956641043764185
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 2795288470475780636
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17848342247887153727
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 12025174899449725934
        Name: "ArrowEndPos"
        Transform {
          Location {
            Y: 800
            Z: -1.73182678
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 1348435041801658242
        Name: "ArrowPos2"
        Transform {
          Location {
            Y: -300
            Z: 122.620972
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        ChildIds: 7130600075036769077
        UnregisteredParameters {
          Overrides {
            Name: "cs:ArrowPos2"
            ObjectReference {
              SubObjectId: 1348435041801658242
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos2"
            ObjectReference {
              SubObjectId: 4061064452304388728
            }
          }
          Overrides {
            Name: "cs:ArrowPos3"
            ObjectReference {
              SubObjectId: 17396630222178160669
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos3"
            ObjectReference {
              SubObjectId: 12215109131940877006
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 7130600075036769077
        Name: "ArrowHole"
        Transform {
          Location {
            X: 0.175048828
            Y: 50
            Z: -15.1619263
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 1348435041801658242
        ChildIds: 9316867880847344592
        ChildIds: 15162766252331398739
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 9316867880847344592
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            X: -0.174987793
            Y: -3.58477783
          }
          Rotation {
          }
          Scale {
            X: 0.314033568
            Y: 0.438337445
            Z: 0.281833619
          }
        }
        ParentId: 7130600075036769077
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14492599398820280602
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 15162766252331398739
        Name: "Pipe - 4-Sided Thick"
        Transform {
          Location {
            X: 0.174987793
            Y: 3.58477783
            Z: 12.6639557
          }
          Rotation {
            Roll: 89.9999084
          }
          Scale {
            X: 0.376865923
            Y: 0.376865923
            Z: 0.184485152
          }
        }
        ParentId: 7130600075036769077
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 2795288470475780636
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17848342247887153727
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 4061064452304388728
        Name: "ArrowEndPos2"
        Transform {
          Location {
            Y: 800
            Z: 122.620972
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "cs:ArrowPos2"
            ObjectReference {
              SubObjectId: 1348435041801658242
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos2"
            ObjectReference {
              SubObjectId: 4061064452304388728
            }
          }
          Overrides {
            Name: "cs:ArrowPos3"
            ObjectReference {
              SubObjectId: 17396630222178160669
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos3"
            ObjectReference {
              SubObjectId: 12215109131940877006
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 17396630222178160669
        Name: "ArrowPos3"
        Transform {
          Location {
            Y: -300
            Z: 256.679169
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        ChildIds: 8174575180941695900
        UnregisteredParameters {
          Overrides {
            Name: "cs:ArrowPos2"
            ObjectReference {
              SubObjectId: 1348435041801658242
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos2"
            ObjectReference {
              SubObjectId: 4061064452304388728
            }
          }
          Overrides {
            Name: "cs:ArrowPos3"
            ObjectReference {
              SubObjectId: 17396630222178160669
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos3"
            ObjectReference {
              SubObjectId: 12215109131940877006
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 8174575180941695900
        Name: "ArrowHole"
        Transform {
          Location {
            X: 0.175048828
            Y: 50
            Z: -15.1619263
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 17396630222178160669
        ChildIds: 16139122962141917520
        ChildIds: 1444253716412343271
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 16139122962141917520
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            X: -0.174987793
            Y: -3.58477783
          }
          Rotation {
          }
          Scale {
            X: 0.314033568
            Y: 0.438337445
            Z: 0.281833619
          }
        }
        ParentId: 8174575180941695900
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14492599398820280602
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 1444253716412343271
        Name: "Pipe - 4-Sided Thick"
        Transform {
          Location {
            X: 0.174987793
            Y: 3.58477783
            Z: 12.6639557
          }
          Rotation {
            Roll: 89.9999084
          }
          Scale {
            X: 0.376865923
            Y: 0.376865923
            Z: 0.184485152
          }
        }
        ParentId: 8174575180941695900
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 2795288470475780636
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17848342247887153727
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
      Objects {
        Id: 12215109131940877006
        Name: "ArrowEndPos3"
        Transform {
          Location {
            Y: 800
            Z: 235.093536
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "cs:ArrowPos2"
            ObjectReference {
              SubObjectId: 1348435041801658242
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos2"
            ObjectReference {
              SubObjectId: 4061064452304388728
            }
          }
          Overrides {
            Name: "cs:ArrowPos3"
            ObjectReference {
              SubObjectId: 17396630222178160669
            }
          }
          Overrides {
            Name: "cs:ArrowEndPos3"
            ObjectReference {
              SubObjectId: 12215109131940877006
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 18340645352516477508
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            Y: -292.719482
            Z: -50.5308533
          }
          Rotation {
          }
          Scale {
            X: 0.8107301
            Y: 1.1361171
            Z: 3.59812593
          }
        }
        ParentId: 2303106816200482418
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14470038530306782275
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          EnableCameraCollision: true
          StaticMesh {
            Physics {
            }
          }
        }
      }
    }
    Assets {
      Id: 15870650808192187890
      Name: "Recurve Bow Fire Release Arrow Heavy 01 SFX"
      PlatformAssetType: 7
      PrimaryAsset {
        AssetType: "AudioAssetRef"
        AssetId: "sfx_recurve_bow_fire_release_arrow_heavy_01a_Cue_ref"
      }
    }
    Assets {
      Id: 17609149353171719671
      Name: "Cube - bottom aligned"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_cube_001"
      }
    }
    Assets {
      Id: 14470038530306782275
      Name: "Bone Raw"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_bone_raw_001_uv_ref"
      }
    }
    Assets {
      Id: 14492599398820280602
      Name: "Rubber Dot Panels 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_scf_rubber_panels_001_uv"
      }
    }
    Assets {
      Id: 17848342247887153727
      Name: "Pipe - 4-Sided Thick"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_pipe_4_sided_thick_001"
      }
    }
    Assets {
      Id: 2795288470475780636
      Name: "Bricks Stone Block 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_bricks_stone_block_001"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Description: "I modified the arrow trap by LanaLux to shoot automaticly"
  }
  SerializationVersion: 65
  DirectlyPublished: true
}
