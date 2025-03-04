SELECT 1 DUMY,
       IT.ITEM_TYPE_DESC,
       IMT.ITEM_CODE,
       IMT.ITEM_DESC,
       UOM.UOM_TINY_DESC,
       sec_uom.UOM_TINY_DESC,
       NOI,
       0 BALANCE_AMOUNT,
       BALANCE,
       SEC_BALANCE,
       '-1' CODE_VALUE,
       '-1' CODE_DESC
  FROM ITEMS_MT IMT,
       WIZ_UOM_MT UOM,
       items_inventory ii,
       wiz_uom_mt sec_uom,
       WIZ_ITEM_TYPE_MT IT,
       (SELECT 1,
               IMT.ITEM_ID,
               COUNT(1) NOI,
               SUM(i.PQTYBAL) BALANCE,
               SUM(i.SQTYBAL) SEC_BALANCE
          FROM ITEMS_MT IMT,
             --  temp_item_criteria ti,
             --  CODE_COMBINATIONS CC,
               (SELECT imt.item_id,
                       NVL(OP.PQTY, 0) +
                       (NVL(GRN.PQTY, 0) + NVL(PROD.PQTY, 0) +
                        NVL(RI.PQTY, 0) + NVL(IR.PQTY, 0) + NVL(TR.PQTY, 0)) -
                       (NVL(TI.PQTY, 0) + NVL(RO.PQTY, 0) + NVL(D.PQTY, 0) +
                        NVL(I.PQTY, 0)) + NVL(ADJ.PQTY, 0) PQTYBAL,
                       
                       NVL(OP.AMT, 0) +
                       (NVL(GRN.AMT, 0) + NVL(PROD.AMT, 0) + NVL(RI.AMT, 0) +
                        NVL(IR.AMT, 0) + NVL(TR.AMT, 0)) -
                       (NVL(TI.AMT, 0) + NVL(RO.AMT, 0) + NVL(D.AMT, 0) +
                        NVL(I.AMT, 0)) + NVL(ADJ.AMT, 0) AMTBAL,
                       
                       NVL(OP.SQTY, 0),
                       + (NVL(GRN.SQTY, 0) + NVL(PROD.SQTY, 0) +
                         NVL(RI.SQTY, 0) + NVL(IR.SQTY, 0) + NVL(TR.SQTY, 0)) -
                        (NVL(TI.SQTY, 0) + NVL(RO.SQTY, 0) + NVL(D.SQTY, 0) +
                         NVL(I.SQTY, 0)) + NVL(ADJ.SQTY, 0) SQTYBAL
                
                  FROM items_mt imt,
                      -- TEMP_ITEM_CRITERIA T,
                       (SELECT IB.item_id,
                               COUNT(1) cnt,
                               SUM(IB.PRI_CL_BAL_QTY) PQTY,
                               SUM(IB.CLOSING_VALUE) AMT,
                               SUM(IB.SEC_CL_BAL_QTY) SQTY
                          FROM INVENTORY_BALANCES             IB,
                            --   TEMP_ITEM_CRITERIA             TI,
                           --    TEMP_CODE_COMBINATION_CRITERIA TC,
                               sub_inventory_mt               SI
                         WHERE IB.SUB_INV_ID = SI.SUB_INV_ID
                         --  AND IB.ITEM_ID = TI.ITEM_ID
                           AND IB.FIN_YEAR_ID = :PREV_YR_ID
                           AND IB.SUB_INV_ID = &SUB_INV_ID
                         --  AND IB.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY IB.item_id) OP,
                       (SELECT gd.item_id,
                               COUNT(1) cnt,
                               SUM(GD.PRIMARY_ACCEPTED_QTY) PQTY,
                               SUM(GD.GRN_LINE_AMOUNT) AMT,
                               SUM(GD.SECONDRY_ACCEPTED_QTY) SQTY
                          FROM grn_mt                         gm,
                               grn_detail                     gd,
															 inv_books_mt                   ibm
                            --   TEMP_INV_BOOKS_CRITERIA        TB,
                              -- TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE gm.grn_id = gd.grn_id
												 and gm.inv_book_id = ibm.inv_book_id
												 and ibm.sub_inv_id = &SUB_INV_ID
                        --   AND GM.INV_BOOK_ID = TB.INV_BOOK_ID
                         --  AND GD.ITEM_ID = TI.ITEM_ID
                           AND gm.grn_date BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                         --  AND GD.CODE_COMBINATION_ID = TC.CODE_COMBINATION_ID
                         GROUP BY gd.item_id
												 ) grn,
                       (SELECT PD.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(PD.QTY_PRODUCED) PQTY,
                               SUM(PD.STANDARD_AMOUNT) AMT,
                               SUM(PD.SEC_QTY_PROD) SQTY
                          FROM PRODUCTION_MT                  PM,
                               PRODUCTION_DETAIL              PD,
                               INV_BOOKS_MT                   IBM
															-- TEMP_INV_BOOKS_CRITERIA        TB,
                               --TEMP_ITEM_CRITERIA             TI,
                               --TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE PM.PROD_ID = PD.PROD_ID
                          AND PM.INV_BOOK_ID = IBM.INV_BOOK_ID
													AND IBM.SUB_INV_ID = &SUB_INV_ID
													
													-- AND PM.INV_BOOK_ID = TB.INV_BOOK_ID
                          -- AND PD.ITEM_ID = TI.ITEM_ID
                           AND PM.PROD_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                          -- AND PD.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY PD.ITEM_ID) PROD,
                       (SELECT RID.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(RID.PRI_ACCEPTED_QTY) PQTY,
                               SUM(RID.RMA_IN_LINE_AMOUNT) AMT,
                               SUM(RID.SEC_ACCEPTED_QTY) SQTY
                          FROM RMA_INWARD_MT                  RIM,
                               RMA_INWARD_DET                 RID,
                              INV_BOOK_MT                     IBM
															-- TEMP_INV_BOOKS_CRITERIA        TB,
                              -- TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE RIM.RMA_INWARD_ID = RID.RMA_INWARD_ID
                          AND RIM.INV_BOOK_ID = IBM.INV_BOOK_ID
													AND IBM.SUB_INV_ID = &SUB_INV_ID
													
													-- AND RIM.INV_BOOK_ID = TB.INV_BOOK_ID
                       --    AND RID.ITEM_ID = TI.ITEM_ID
                           AND RIM.RMA_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                         --  AND RID.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY RID.ITEM_ID) RI,
                       (SELECT ID.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(ID.PRIMARY_QTY) PQTY,
                               SUM(ID.ISSUE_AMOUNT) AMT,
                               SUM(ID.SECONDARY_QTY) SQTY
                          FROM ISSUE_MT                       IM,
                               ISSUE_DETAIL                   ID,
                             INV_BOOKS_MT                     IBM
														 --  TEMP_INV_BOOKS_CRITERIA        TB,
                             --  TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE IM.ISSUE_ID = ID.ISSUE_ID
                          AND IM.INV_BOOK_ID = IBM.INV_BOOK_ID
													AND IBM.SUB_INV_ID = &SUB_INV_ID
													-- AND IM.INV_BOOK_ID = TB.INV_BOOK_ID
                        --   AND ID.ITEM_ID = TI.ITEM_ID
                           AND IM.ISSUE_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                           AND IM.TRANS_TYPE = 'R'
                        --   AND ID.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY ID.ITEM_ID) IR,
                       (SELECT tid.item_id,
                               COUNT(1) cnt,
                               SUM(TRD.PRIMARY_QTY) PQTY,
                               SUM(TID.AMOUNT) AMT,
                               SUM(TRD.SECONDARY_QTY) SQTY
                          FROM trans_rct_mt                   trm,
                               trans_rct_det                  trd,
                               trans_issue_detail             tid,
                               INV_BOOKS_MT                   IBM
															-- TEMP_INV_BOOKS_CRITERIA        TB,
                              -- TEMP_ITEM_CRITERIA             TI,
                               --TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE trm.rct_trans_id = trd.rct_trans_id
                           AND TRM.INV_BOOK_ID = IBM.INV_BOOK_ID
													 AND IBM.SUB_INV_ID = &SUB_INV_ID
													 --AND TRM.INV_BOOK_ID = TB.INV_BOOK_ID
                         --  AND TID.ITEM_ID = TI.ITEM_ID
                           AND trd.iss_trans_det_id = tid.iss_trans_det_id
                           AND trm.receipt_date BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                        --   AND TRD.LOCATOR_CODE_COMB_ID =
                          --     TC.CODE_COMBINATION_ID
                         GROUP BY tid.item_id) tr,
                       (SELECT TID.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(TID.PIRMARY_QTY) PQTY,
                               SUM(TID.AMOUNT) AMT,
                               SUM(TID.SECONDARY_QTY) SQTY
                          FROM TRANS_ISSUE_MT                 TIM,
                               TRANS_ISSUE_DETAIL             TID,
															 INV_BOOK_MT                    IBM
                            --   TEMP_INV_BOOKS_CRITERIA        TB,
                            --   TEMP_ITEM_CRITERIA             TI,
                             --  TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE TIM.ISS_TRANS_ID = TID.ISS_TRANS_ID
                         AND TIM.INV_BOOK_ID = IBM.INV_BOOK_ID
												 AND IBM.SUB_INV_ID = &SUB_INV_ID
											 --    AND TIM.INV_BOOK_ID = TB.INV_BOOK_ID
                         --  AND TID.ITEM_ID = TI.ITEM_ID
                           AND TIM.TRANS_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                         --  AND TID.FROM_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY TID.ITEM_ID) TI,
                       (SELECT ROD.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(ROD.PRI_ACCEPTED_QTY) PQTY,
                               SUM(ROD.RMA_OUT_LINE_AMOUNT) AMT,
                               SUM(ROD.SEC_ACCEPTED_QTY) SQTY
                          FROM RMA_OUTWARD_MT                 ROM,
                               RMA_OUTWARD_DET                ROD,
															 INV_BOOKS_MT                   IBM
                             --  TEMP_INV_BOOKS_CRITERIA        TB,
                              -- TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE ROM.RMA_OUT_ID = ROD.RMA_OUT_ID
                         AND ROM.INV_BOOK_ID = IBM.INV_BOOK_ID
												 AND IBM.SUB_INV_ID = &SUB_INV_ID
												 --  AND ROM.INV_BOOK_ID = TB.INV_BOOK_ID
                          -- AND ROD.ITEM_ID = TI.ITEM_ID
                           AND ROM.RMA_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                           --AND ROD.LOC_CODE_COMBINATION_ID =
                             --  TC.CODE_COMBINATION_ID
                         GROUP BY ROD.ITEM_ID) RO,
                       (SELECT DD.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(DD.PRIMARY_QTY) PQTY,
                               SUM(DD.COST_OF_SALE) AMT,
                               SUM(DD.SECONDARY_QTY) SQTY
                          FROM DC_MT                          DM,
                               DC_DETAIL                      DD,
															 INV_BOOKS_MT                   IBM
                             --  TEMP_INV_BOOKS_CRITERIA        TB,
                             --  TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE DM.DC_ID = DD.DC_ID
                       AND DM.INV_BOOK_ID = IBM.INV_BOOK_ID
											 AND IBM.SUB_INV_ID = &SUB_INV_ID
											 
											 --    AND DM.INV_BOOK_ID = TB.INV_BOOK_ID
                        --   AND DD.ITEM_ID = TI.ITEM_ID
                           AND DM.DC_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                      --     AND DD.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY DD.ITEM_ID) D,
                       (SELECT ID.ITEM_ID,
                               COUNT(1) CNT,
                               SUM(ID.PRIMARY_QTY) PQTY,
                               SUM(ID.ISSUE_AMOUNT) AMT,
                               SUM(ID.SECONDARY_QTY) SQTY
                          FROM ISSUE_MT                       IM,
                               ISSUE_DETAIL                   ID,
															 INV_BOOKS_MT                   IBM
                             --  TEMP_INV_BOOKS_CRITERIA        TB,
                            --   TEMP_ITEM_CRITERIA             TI,
                           --    TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE IM.ISSUE_ID = ID.ISSUE_ID
                         AND IM.INV_BOOK_ID = IBM.INV_BOOK_ID
												 AND IBM.SUB_INV_ID = &SUB_INV_ID
												 --  AND IM.INV_BOOK_ID = TB.INV_BOOK_ID
                          -- AND ID.ITEM_ID = TI.ITEM_ID
                           AND IM.ISSUE_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                           AND IM.TRANS_TYPE = 'I'
                          -- AND ID.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY ID.ITEM_ID) I,
                       (SELECT AD.item_id,
                               COUNT(1) cnt,
                               SUM(AD.PRIMARY_QTY) PQTY,
                               SUM(AD.LINE_AMOUNT) AMT,
                               SUM(AD.SECONDARY_QTY) SQTY
                          FROM ITEM_ADJUSTMENT_MT             AM,
                               ITEM_ADJUSTMENT_DET            AD,
                               INV_BOOKS_MT                   IBM  
													  -- TEMP_INV_BOOKS_CRITERIA        TB,
                              -- TEMP_ITEM_CRITERIA             TI,
                              -- TEMP_CODE_COMBINATION_CRITERIA TC
                         WHERE AM.ITEM_ADJUSTMENT_ID = AD.ITEM_ADJUSTMENT_ID
                           AND AM.INV_BOOK_ID = IBM.INV_BOOK_ID
													 AND IBM.SUB_INV_ID = &SUB_INV_ID
													 --AND AM.INV_BOOK_ID = TB.INV_BOOK_ID
                           --AND AD.ITEM_ID = TI.ITEM_ID
                           AND AM.ADJUSTMENT_DATE BETWEEN :THIS_YR_START_DATE AND
                               :PARM_ON_DATE
                           --AND AD.LOC_CODE_COMB_ID = TC.CODE_COMBINATION_ID
                         GROUP BY AD.item_id) ADJ
                 WHERE imt.item_id = grn.item_id(+)
                   AND IMT.ITEM_ID = PROD.ITEM_ID(+)
                   AND IMT.ITEM_ID = RI.ITEM_ID(+)
                   AND IMT.ITEM_ID = IR.ITEM_ID(+)
                   AND imt.item_id = tr.item_id(+)
                   AND IMT.ITEM_ID = TI.ITEM_ID(+)
                   AND IMT.ITEM_ID = RO.ITEM_ID(+)
                   AND IMT.ITEM_ID = D.ITEM_ID(+)
                   AND IMT.ITEM_ID = I.ITEM_ID(+)
                   AND IMT.ITEM_ID = OP.ITEM_ID(+)
                   AND IMT.ITEM_ID = ADJ.ITEM_ID(+)
                   --AND IMT.ITEM_ID = T.ITEM_ID
									 ) I
        
         WHERE 1 = 1
           --and IMT.item_id = ti.item_id
           --and ti.code_combination_id = cc.code_combination_id(+)
           AND IMT.ITEM_ID = I.ITEM_ID(+)
         GROUP BY (IMT.ITEM_ID)) TRANS
 WHERE (TRANS.BALANCE <> 0 OR TRANS.SEC_BALANCE <> 0)
   AND IMT.ITEM_TYPE_ID = IT.ITEM_TYPE_ID
   AND TRANS.ITEM_ID = IMT.ITEM_ID(+)
   AND IMT.PRIMARY_UOM = UOM.UOM_ID(+)
   AND IMT.item_id = ii.item_id(+)
   and ii.secondary_uom = sec_UOM.UOM_ID(+)
 ORDER BY ITEM_CODE
