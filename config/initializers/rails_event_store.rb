require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new(
    mapper: RubyEventStore::Mappers::Default.new(serializer: JSON)
  )
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
    store.subscribe(InventoryControls::OnStockHandler,
                    to: [
                        InventoryControlling::StockCameIn,
                        InventoryControlling::StockCameOut,
                        InventoryControlling::StockAdjusted,
                        InventoryControlling::StockTransferred,
                        InventoryControlling::StockReserved
                    ]
    )

    store.subscribe(InventoryControls::OnProductStockHandler,
                    to: [
                        InventoryControlling::StockCameIn,
                        InventoryControlling::StockCameOut,
                        InventoryControlling::StockAdjusted,
                        InventoryControlling::StockReserved
                    ]
    )

    store.subscribe(Orders::OnOrderHandler, to: [Ordering::OrderPlaced, Ordering::OrderLeft, Ordering::OrderPrepared])

    store.subscribe(StockReserveProcess, to: [Ordering::OrderPlaced, InventoryControlling::ReserveAdditionalStock])
    store.subscribe(StockLeaveProcess, to: [Ordering::OrderPrepared])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(InventoryControlling::ComeInStock, InventoryControlling::OnComeInStock.new)
    bus.register(InventoryControlling::ComeOutStock, InventoryControlling::OnComeOutStock.new)
    bus.register(InventoryControlling::AdjustStock, InventoryControlling::OnAdjustStock.new)
    bus.register(InventoryControlling::TransferStock, InventoryControlling::OnTransferStock.new)
    bus.register(InventoryControlling::ReserveStock, InventoryControlling::OnReserveStock.new)

    bus.register(Ordering::PlaceOrder, Ordering::OnPlaceOrder.new)
    bus.register(Ordering::PrepareOrder, Ordering::OnPrepareOrder.new)
    bus.register(Ordering::LeaveOrder, Ordering::OnLeaveOrder.new)
  end
end