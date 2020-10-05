Assets {
  Id: 10047096576092887913
  Name: "FireTrapAutomatic"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 13457797889925135102
      Objects {
        Id: 13457797889925135102
        Name: "FireTrapAutomatic"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 7393632919856220627
        ChildIds: 13910847543939740214
        ChildIds: 14412336599206809581
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
        Id: 7393632919856220627
        Name: "FireSwitch"
        Transform {
          Location {
            X: -1095.6875
            Y: -177.601196
            Z: 46.5440369
          }
          Rotation {
            Pitch: -0.000184415097
            Yaw: -5.000247
            Roll: 136.444382
          }
          Scale {
          }
        }
        ParentId: 13457797889925135102
        UnregisteredParameters {
          Overrides {
            Name: "cs:FirePosition"
            ObjectReference {
              SubObjectId: 3586267869074101428
            }
          }
          Overrides {
            Name: "cs:FireBlast"
            AssetReference {
              Id: 15997575844654033997
            }
          }
          Overrides {
            Name: "cs:FirePositionTop"
            ObjectReference {
              SubObjectId: 855827603273842979
            }
          }
          Overrides {
            Name: "cs:Dir"
            Bool: false
          }
          Overrides {
            Name: "cs:FireBlast2"
            AssetReference {
              Id: 4277014970798748663
            }
          }
          Overrides {
            Name: "cs:BlastDuration"
            Float: 6
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
            Id: 6066362316971647369
          }
        }
      }
      Objects {
        Id: 13910847543939740214
        Name: "FireTrap"
        Transform {
          Location {
            X: -516.112061
            Y: -129.695679
            Z: -54.949707
          }
          Rotation {
            Yaw: -4.12698364
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 13457797889925135102
        ChildIds: 2767622460343687506
        ChildIds: 3586267869074101428
        ChildIds: 7661322268074687923
        ChildIds: 7452409739543324726
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
        Id: 2767622460343687506
        Name: "ClientContext"
        Transform {
          Location {
            X: 7.65257359
            Y: -117.202042
            Z: 12.3380127
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 13910847543939740214
        ChildIds: 3321099130337019835
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 3321099130337019835
        Name: "Geo"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 2767622460343687506
        ChildIds: 8411674254671602724
        ChildIds: 5789710871369940055
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
        Id: 8411674254671602724
        Name: "Base"
        Transform {
          Location {
            Y: 16.1610794
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 0.186761215
            Z: 1.22203422
          }
        }
        ParentId: 3321099130337019835
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
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
        Id: 5789710871369940055
        Name: "Skull"
        Transform {
          Location {
            Y: -16.1610794
            Z: 32.0962639
          }
          Rotation {
          }
          Scale {
            X: 3.98808932
            Y: 3.98808932
            Z: 3.98808932
          }
        }
        ParentId: 3321099130337019835
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 13417453355201377219
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
        Id: 3586267869074101428
        Name: "Position"
        Transform {
          Location {
            X: -22.7464752
            Y: -61.9633293
            Z: 32.8110352
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 13910847543939740214
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsFilePartition: true
          FilePartitionName: "Position"
        }
      }
      Objects {
        Id: 7661322268074687923
        Name: "StartFire"
        Transform {
          Location {
            X: -33.9721146
            Y: -31.5106678
            Z: 67.442627
          }
          Rotation {
          }
          Scale {
          }
        }
        ParentId: 13910847543939740214
        UnregisteredParameters {
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
          }
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SubObjectId: 7452409739543324726
            }
          }
          Overrides {
            Name: "cs:FireSwitch"
            ObjectReference {
              SubObjectId: 7393632919856220627
            }
          }
          Overrides {
            Name: "cs:Dir"
            Bool: true
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 5640149647178906419
          }
        }
      }
      Objects {
        Id: 7452409739543324726
        Name: "Trigger"
        Transform {
          Location {
            X: 7.84841347
            Y: 171.528336
            Z: 92.0861816
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 4.96348906
            Z: 1
          }
        }
        ParentId: 13910847543939740214
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
        Id: 14412336599206809581
        Name: "FireTrapTop"
        Transform {
          Location {
            X: -516.112061
            Y: -129.695679
            Z: 100
          }
          Rotation {
            Yaw: -4.12698364
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 13457797889925135102
        ChildIds: 7139755352139239906
        ChildIds: 855827603273842979
        ChildIds: 16906048058127788332
        ChildIds: 9678408652952434414
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
        Id: 7139755352139239906
        Name: "ClientContext"
        Transform {
          Location {
            X: 7.65254593
            Y: -117.20208
            Z: 12.3380241
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 14412336599206809581
        ChildIds: 5412502702309422794
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 5412502702309422794
        Name: "Geo"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 7139755352139239906
        ChildIds: 18130349753841939469
        ChildIds: 15417558128054707886
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
        Id: 18130349753841939469
        Name: "Base"
        Transform {
          Location {
            X: 1.87107362e-05
            Y: 16.1610775
            Z: -2.29664612
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 0.186761215
            Z: 1.22203422
          }
        }
        ParentId: 5412502702309422794
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
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
        Id: 15417558128054707886
        Name: "Skull"
        Transform {
          Location {
            Y: -16.1610794
            Z: 32.0962639
          }
          Rotation {
          }
          Scale {
            X: 3.98808932
            Y: 3.98808932
            Z: 3.98808932
          }
        }
        ParentId: 5412502702309422794
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 13417453355201377219
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
        Id: 855827603273842979
        Name: "Position"
        Transform {
          Location {
            X: -23.2817535
            Y: -61.9633293
            Z: 32.8110352
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 14412336599206809581
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsFilePartition: true
          FilePartitionName: "Position"
        }
      }
      Objects {
        Id: 16906048058127788332
        Name: "StartFire"
        Transform {
          Location {
            X: -0.221993327
            Y: -31.5107422
            Z: 67.442627
          }
          Rotation {
          }
          Scale {
          }
        }
        ParentId: 14412336599206809581
        UnregisteredParameters {
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
          }
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SubObjectId: 9678408652952434414
            }
          }
          Overrides {
            Name: "cs:FireSwitch"
            ObjectReference {
              SubObjectId: 7393632919856220627
            }
          }
          Overrides {
            Name: "cs:FireOnTop"
            Bool: true
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 5640149647178906419
          }
        }
      }
      Objects {
        Id: 9678408652952434414
        Name: "Trigger"
        Transform {
          Location {
            X: 7.89608431
            Y: 172.073883
            Z: 92.0861816
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 4.96348906
            Z: 1
          }
        }
        ParentId: 14412336599206809581
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
      Id: 14975829920875445012
      Name: "Rock Obsidian 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_fresnel_rock_obsidian_001_uv"
      }
    }
    Assets {
      Id: 13417453355201377219
      Name: "Bone Human Skull 01"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_bones_human_skull_01_ref"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Description: "I modified the original fire trap by LanaLux toswitch after a given period of time"
  }
  SerializationVersion: 65
  DirectlyPublished: true
}
