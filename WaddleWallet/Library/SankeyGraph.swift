//
//  SankeyGraph.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/19/25.
//

import SwiftUI

struct SankeyData {
    let nodes: [SankeyNode]
    let links: [SankeyLink]
}

struct SankeyNode: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let color: Color

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SankeyNode, rhs: SankeyNode) -> Bool {
        lhs.id == rhs.id
    }
}

struct SankeyLink {
    let from: SankeyNode
    let to: SankeyNode
    let amount: Double
}

extension Array where Element == SankeyLink {
    func gatherTotalAmount() -> Double {
        reduce(0) { $0 + $1.amount }
    }
}

struct SankeyCanvas: View {
    let nodes: [SankeyNode] = [
        SankeyNode(name: "A", color: .gray),
        SankeyNode(name: "B", color: .red),
        SankeyNode(name: "C", color: .blue),
        SankeyNode(name: "D", color: .orange),
        SankeyNode(name: "E", color: .purple),
        SankeyNode(name: "F", color: .green),
        SankeyNode(name: "G", color: .indigo),
        SankeyNode(name: "H", color: .brown),
        SankeyNode(name: "I", color: .mint)
    ]

    var links: [SankeyLink] {
        [
            SankeyLink(from: nodes[0], to: nodes[3], amount: 1000),
            SankeyLink(from: nodes[0], to: nodes[2], amount: 800),
            SankeyLink(from: nodes[0], to: nodes[1], amount: 1100),
            SankeyLink(from: nodes[0], to: nodes[4], amount: 30000),
            SankeyLink(from: nodes[0], to: nodes[5], amount: 1000),
            SankeyLink(from: nodes[0], to: nodes[6], amount: 800),
            SankeyLink(from: nodes[0], to: nodes[7], amount: 1100),
            SankeyLink(from: nodes[0], to: nodes[8], amount: 30000)
        ]
    }

    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let endX: CGFloat = size.width

                // Total link amount
                let total = links.gatherTotalAmount()

                // Layout end nodes
                let endNodeAmounts = Dictionary(grouping: links, by: { $0.to })
                    .mapValues { $0.reduce(0) { $0 + $1.amount } }

                let endNodes = endNodeAmounts
                    .sorted { $0.value > $1.value } // Descending order by amount
                    .map { $0.key }
                
                let spacing = size.height / CGFloat(endNodes.count + 1)

                var nodePositions: [UUID: CGPoint] = [:]
                for (i, node) in endNodes.enumerated() {
                    let point = CGPoint(x: endX, y: spacing * CGFloat(i + 1))
                    nodePositions[node.id] = point
                }

                // Define source rectangle
                let sourceNode = nodes[0]
                let sourceWidth: CGFloat = 30
                let maxHeight: CGFloat = size.height * 0.25
                let scale: CGFloat = maxHeight / CGFloat(total)
                let sourceHeight = CGFloat(total) * scale
                let startY: CGFloat = size.height / 2

                let sourceRect = CGRect(
                    x: 0,
                    y: startY - sourceHeight / 2,
                    width: sourceWidth,
                    height: sourceHeight - 2
                )

                context.draw(Text(sourceNode.name).font(.caption).fontWeight(.bold).foregroundColor(Color.white),
                             at: CGPoint(x: sourceRect.midX + 30, y: sourceRect.minY + 32))
                context.draw(Text("\(links.gatherTotalAmount().currencyFormatted)").font(.caption2).fontWeight(.bold).foregroundColor(Color.white),
                             at: CGPoint(x: sourceRect.midX + 30, y: sourceRect.minY + 50))

                var currentYOffset: CGFloat = 0

                let sortedLinks = links.sorted { $0.amount >= $1.amount }
                
                for link in sortedLinks {
                    guard let toPoint = nodePositions[link.to.id] else { continue }

                    let linkHeight = CGFloat(link.amount) * scale
                    let sourceLinkY = sourceRect.minY + currentYOffset + linkHeight / 2
                    let sourcePoint = CGPoint(x: 0, y: sourceLinkY)

                    var path = Path()
                    path.move(to: sourcePoint)

                    let midX = (sourcePoint.x + toPoint.x) / 2
                    path.addCurve(to: toPoint,
                                  control1: CGPoint(x: midX, y: sourcePoint.y),
                                  control2: CGPoint(x: midX, y: toPoint.y))

                    let gradient = Gradient(colors: [link.from.color.opacity(0.8), link.to.color.opacity(0.8)])
                    let strokeStyle = StrokeStyle(lineWidth: linkHeight, lineCap: .square)

                    context.stroke(path,
                                   with: .linearGradient(gradient,
                                                         startPoint: sourcePoint,
                                                         endPoint: toPoint),
                                   style: strokeStyle)

                    context.draw(Text(link.to.name).font(.caption),
                                 at: CGPoint(x: toPoint.x - 50, y: toPoint.y - 8))
                    context.draw(Text("\(link.amount.currencyFormatted)").font(.caption2),
                                 at: CGPoint(x: toPoint.x - 50, y: toPoint.y + 8))

                    currentYOffset += linkHeight
                }
            }
        }
        .frame(width: .infinity, height: 400)
    }
}



#Preview {
    SankeyCanvas()
}
