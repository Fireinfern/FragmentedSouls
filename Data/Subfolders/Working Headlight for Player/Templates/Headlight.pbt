Assets {
  Id: 8968402435106291397
  Name: "Headlight"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 12060261115952448602
      Objects {
        Id: 12060261115952448602
        Name: "HeadlightParent"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8568336417442047963
        ChildIds: 5013332650253618921
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceoff"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 5013332650253618921
        Name: "Headlight"
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
        ParentId: 12060261115952448602
        ChildIds: 13053493707258544241
        ChildIds: 4950822083398423913
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 13053493707258544241
        Name: "attachflashlight"
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
        ParentId: 5013332650253618921
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 8426941618525948718
          }
        }
      }
      Objects {
        Id: 4950822083398423913
        Name: "flashlight001"
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
        ParentId: 5013332650253618921
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Light {
          Intensity: 51.4053764
          Color {
            R: 1
            G: 1
            B: 1
            A: 1
          }
          VolumetricIntensity: 5
          TeamSettings {
          }
          Light {
            Temperature: 6500
            LocalLight {
              AttenuationRadius: 2449.88354
              SpotLight {
                SourceRadius: 20
                SoftSourceRadius: 20
                FallOffExponent: 8
                UseFallOffExponent: true
                InnerConeAngle: 5.96733761
                OuterConeAngle: 26.9724865
                Profile {
                  Value: "mc:espotlightprofile:basicspotlight"
                }
              }
            }
            MaxDrawDistance: 5000
            MaxDistanceFadeRange: 1000
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Description: "A light and a script that attaches it to the players head.  No Model.  Very simple template.  Add anywhere to level and it makes player have a headlight.  "
  }
  SerializationVersion: 65
  DirectlyPublished: true
}
