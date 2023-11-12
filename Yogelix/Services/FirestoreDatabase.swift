//  FirestoreDatabase.swift
import Foundation
import FirebaseCore
import FirebaseFirestore

let db = Firestore.firestore()

let crownChakra = db.document("/chakras/CrownChakra")
let thirdEyeChakra = db.document("/chakras/ThirdEyeChakra")
let throatChakra = db.document("/chakras/ThroatChakra")
let heartChakra = db.document("/chakras/HeartChakra")
let solarPlexusChakra = db.document("/chakras/SolarPlexusChakra")
let sacralChakra = db.document("/chakras/SacralChakra")
let rootChakra = db.document("/chakras/RootChakra")

let focusPoints: [DocumentReference] = [crownChakra, thirdEyeChakra, throatChakra, heartChakra, solarPlexusChakra, sacralChakra, rootChakra]

