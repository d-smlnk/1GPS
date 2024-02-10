//
//  TrackerModel.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation

struct TrackerModel: Decodable {
    let id: String?// UInt
    let km10: String?//Double                    //    км*10 пробег за выбранный интервал
    let maxspeed: String?//Double                //    км/ч макс.скорость за выбранный интервал
    let enginetime: String?//Double              //    сек работа двигателя за выбранный интервал
    let tlast: String?//Int                      //    unixtime когда получены последние данные
    let tvalid: String?//Int                     //    unixtime последние валидные координаты
    let tarc: String?//Int                       //    unixtime последние данные в непрерывном архиве
    let lat: String?//Int?                       //    град.*1000000 широта
    let lng: String?//Int?                       //    град.*1000000 долгота
    let azi: String?//Int                        //    градусы азимут
    let speed: String?//Double                   //    км/ч скорость
    let alt: String?//Int                        //    метры высота
    let lat6: String?//Int                       //    град.*600000 широта
    let lng6: String?//Int                       //    град.*600000 долгота
    let csq: String?                             //    состояния датчика
}

